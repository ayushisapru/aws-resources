region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_security_group" "sg" {
  name_prefix = "alb_sg"
  vpc_id      = var.vpc_id
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
@@ -22,8 +26,8 @@ resource "aws_security_group" "sg" {
}

resource "aws_subnet" "subnet" {
  count = length(var.subnet_ids)
  vpc_id     = var.vpc_id
  count = length(var.subnet_cidrs)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.subnet_cidrs, count.index)
}
