provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_security_group" "sg" {
  name_prefix = "alb_sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "subnet" {
  count = length(var.subnet_cidrs)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.subnet_cidrs, count.index)
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.9.0"

  name                     = var.alb_name
  internal                 = var.alb_internal
  security_groups          = [aws_security_group.sg.id]
  subnets                  = aws_subnet.subnet[*].id
  enable_deletion_protection = var.enable_deletion_protection
  tags                     = var.tags
}

output "alb_arn" {
  value = module.alb.alb_arn
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
