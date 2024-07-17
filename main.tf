provider "aws" {
  region = var.region
}
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.9.0"
  name                     = var.alb_name
  internal                 = var.alb_internal
  security_groups          = [aws_security_group.sg.id]
  subnets                  = var.subnets  
  subnets                  = aws_subnet.subnet.id
  enable_deletion_protection = var.enable_deletion_protection
  tags                     = var.tags
}
output "alb_arn" {
  value = module.alb.alb_arn
}
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
