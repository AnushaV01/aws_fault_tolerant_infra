variable "project" {}
variable "vpc_id" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "alb_sg_id" {}
variable "ec2_sg_id" {}
variable "iam_instance_profile" {}
variable "instance_type" { default = "t3.micro" }
variable "tags" { type = map(string) }
