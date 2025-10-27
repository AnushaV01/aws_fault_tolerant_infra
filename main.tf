module "vpc" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  project              = var.project
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}