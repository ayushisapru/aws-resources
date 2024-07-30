provider "aws" {
  region = var.region
}

# Fetch the VPC information
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Fetch all subnets in the specified VPC
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

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
/*
resource "aws_launch_template" "example" {
  name_prefix   = "example-lt"
  image_id      = "ami-12345678"  # Replace with your desired AMI ID
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "example-instance"
    }
  }
}
*/
module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "7.7.0"

  name                  = "my-autoscaling-group"
  min_size              = 0
  max_size              = 2
  desired_capacity      = 1
  health_check_type     = "EC2"
  vpc_zone_identifier   = data.aws_subnets.selected.ids
}
