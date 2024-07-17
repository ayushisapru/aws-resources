# defining providers
provider "hcp" {}

provider "aws" {
  region = var.region
}

# fetching information about Packer image
data "hcp_packer_iteration" "ubuntu" {
  bucket_name = var.hcp_bucket_ubuntu
  channel     = var.hcp_channel
}

# uses above to give image info to AWS
data "hcp_packer_image" "ubuntu" {
  bucket_name    = data.hcp_packer_iteration.ubuntu.bucket_name
  iteration_id   = data.hcp_packer_iteration.ubuntu.ulid
  cloud_provider = "aws"
  region         = var.region
}

# generates private key to use for key pair
resource "tls_private_key" "labyrinth" {
  algorithm = "RSA"
}

# defines local var for key file name
locals {
  private_key_filename = "labyrinth-key.pem"
}

# creates key pair used to access ec2 instance
resource "aws_key_pair" "labyrinth_kp" {
  key_name   = local.private_key_filename
  public_key = tls_private_key.labyrinth.public_key_openssh
}

# defines a virtual private cloud - isolated network to launch ec2 instance
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# creates gateway that allows VPC to talk to internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

# defines subnet within vpc to place resources
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_subnet
}

# defines route table to control the routing for network traffic leaving subnets
resource "aws_route_table" "table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# associates the route table with a subnet - determines where network traffic is directed
resource "aws_route_table_association" "table" {
  route_table_id = aws_route_table.table.id
  subnet_id      = aws_subnet.subnet.id
}

# creates security group that acts as a firewall to control traffic
resource "aws_security_group" "sg" {
  name   = "sg"
  vpc_id = aws_vpc.vpc.id

  # allows ssh traffic from any IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allows http traffic from any IP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allows outbound traffic to any IP
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# defining ec2 instance using module
module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "my-ec2-instance"
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.labyrinth_kp.key_name
  ami                         = data.hcp_packer_image.ubuntu.cloud_image_id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "MyEC2Instances"
  }
}

# Application Load Balancer (ALB)
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

# S3 bucket for ALB logs
resource "aws_s3_bucket" "lb_logs" {
  bucket = "my-lb-logs-bucket"
  acl    = "private"
}

# Outputs
output "alb_arn" {
  value = aws_lb.test.arn
}

output "alb_dns_name" {
  value = aws_lb.test.dns_name
}

output "alb_zone_id" {
  value = aws_lb.test.zone_id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

output "subnet_ids" {
  value = aws_subnet.subnet.id
}

output "app_url" {
  value = "http://${module.ec2_instance.public_ip}"
}
