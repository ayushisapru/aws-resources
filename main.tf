# Aws: 
provider "aws" {
  region = "us-west-2"
}


Route 53:
resource "aws_route53_zone" "example" {
  name = "example.com"
}

# Alb:

resource "aws_lb" "example" {
  name               = "example-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.example1.id, aws_subnet.example2.id]
}

# Asg:

resource "aws_autoscaling_group" "example" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.example1.id, aws_subnet.example2.id]
  launch_configuration = aws_launch_configuration.example.id
}


# Rds: 

resource "aws_db_instance" "example" {
  allocated_storage    = var.db_allocated_storage
  engine               = var.db_engine
  instance_class       = var.db_instance_class
  name                 = var.db_name
  username             = var.db_user
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  # VPC security group and subnet group (optional)
  # vpc_security_group_ids = ["sg-12345678"]
  # subnet_group_name = "my_subnet_group"
}


}

