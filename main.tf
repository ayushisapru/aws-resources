provider "aws" {
  region = var.region
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.9.0"

  name                     = var.alb_name
  internal                 = var.alb_internal
  security_groups          = [aws_security_group.sg.id]
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

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "7.7.0"

  name                      = "my-autoscaling-group"
  launch_configuration      = aws_launch_configuration.as_conf.name
  min_size                  = 0
  max_size                  = 2
  desired_capacity          = 1
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.aws_subnets.selected.ids
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_security_group" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

resource "aws_launch_configuration" "as_conf" {
  name          = "web_config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}
