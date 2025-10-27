variable "project" {}
variable "private_subnets" { type = list(string) }
variable "vpc_id" {}
variable "rds_sg_id" {}
variable "instance_class" {}
variable "db_username" {}
variable "db_password" {}
variable "tags" { type = map(string) }
