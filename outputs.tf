output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnets" { value = module.vpc.public_subnets }
output "private_subnets" { value = module.vpc.private_subnets }
output "alb_dns_name" { value = module.compute.alb_dns_name }
output "rds_endpoint" { value = module.database.rds_endpoint }
