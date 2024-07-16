provider "aws" {
  region = var.region
}

module "my_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.9.0"

  name                     = var.alb_name
  internal                 = var.alb_internal
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.subnet.id
  enable_deletion_protection = var.enable_deletion_protection
  tags                     = var.tags
}

output "alb_arn" {
  value = module.my_alb.alb_arn
}

output "alb_dns_name" {
  value = module.my_alb.alb_dns_name
}
