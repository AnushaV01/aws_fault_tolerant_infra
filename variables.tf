variable "region" { 
    default = "ca-central-1" 
}

variable "project" { default = "anusha-project" }

variable "vpc_cidr" { default = "10.0.0.0/16" }

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Owner       = "Anusha"
  }
}
