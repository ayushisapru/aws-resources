provider "aws" {
  region = var.region
}

# retrieve vpc
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# retrieve subnets 
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

# retrieve security group
# Fetch the default security group for the VPC
data "aws_security_group" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.9.0"

  name                       = var.alb_name
  internal                   = var.alb_internal
  security_groups            = [data.aws_security_group.default.id]
  subnets                    = data.aws_subnets.selected.ids
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = var.tags
}

output "alb_arn" {
  value = module.alb.alb_arn
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "7.7.0"

  name                  = "my-autoscaling-group"
  min_size              = 0
  max_size              = 2
  desired_capacity      = 1
  health_check_type     = "EC2"
  vpc_zone_identifier   = data.aws_subnets.selected.ids


  launch_template = {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tags = var.tags 
}
