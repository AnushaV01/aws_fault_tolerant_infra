variable "project" {}
variable "private_subnets" { type = list(string) }
variable "vpc_id" {}
variable "rds_sg_id" {}
variable "instance_class" { default = "db.t3.micro" }
variable "db_username" { default = "admin" }
variable "db_password" { default = "Admin123!" }
variable "tags" { type = map(string) }
