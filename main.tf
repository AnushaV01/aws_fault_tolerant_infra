module "vpc" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  project              = var.project
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "iam" {
  source  = "./modules/iam"
  project = var.project
  tags    = var.tags
}

module "compute" {
  source               = "./modules/compute"
  project              = var.project
  vpc_id               = module.vpc.vpc_id
  public_subnets       = module.vpc.public_subnets
  private_subnets      = module.vpc.private_subnets
  alb_sg_id            = module.security.alb_sg_id
  ec2_sg_id            = module.security.ec2_sg_id
  iam_instance_profile = module.iam.instance_profile
  tags                 = var.tags
}

module "database" {
  source          = "./modules/database"
  project         = var.project
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  rds_sg_id       = module.security.rds_sg_id
  tags            = var.tags
}