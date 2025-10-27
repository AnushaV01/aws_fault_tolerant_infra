data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Project = "${var.project}-vpc" })
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Project = "${var.project}-igw" })
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each = {
    for i, cidr in var.public_subnet_cidrs :
    i => { cidr = cidr, az = local.azs[i] }
  }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Project = var.project, Tier = "Public", Name = "${var.project}-public-${each.key}" })
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = {
    for i, cidr in var.private_subnet_cidrs :
    i => { cidr = cidr, az = local.azs[i] }
  }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags              = merge(var.tags, { Project = var.project, Tier = "Private", Name = "${var.project}-private-${each.key}" })
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  count  = 3
  domain = "vpc"
  tags   = merge(var.tags, { Project = "${var.project}-nat-eip-${count.index}" })
}

# NAT Gateway (one per AZ)
resource "aws_nat_gateway" "nat" {
  count         = 3
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = values(aws_subnet.public)[count.index].id
  tags          = merge(var.tags, { Project = "${var.project}-nat-${count.index}" })
}

# Public Route Table + association
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Project = "${var.project}-public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables (one per AZ)
resource "aws_route_table" "private" {
  for_each = { for idx, nat in aws_nat_gateway.nat : idx => nat }
  vpc_id   = aws_vpc.this.id
  tags     = merge(var.tags, { Project = "${var.project}-private-rt-${each.key}" })
}


# Private routes → NAT
resource "aws_route" "private_nat" {
  for_each               = aws_route_table.private
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[tonumber(each.key)].id
}


# Private subnet associations
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}


