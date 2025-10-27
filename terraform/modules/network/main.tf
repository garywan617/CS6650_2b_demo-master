###########################
# VPC
###########################
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.service_name}-vpc"
  }
}

###########################
# Public Subnets (for ALB)
###########################
resource "aws_subnet" "public_1" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = "10.0.1.0/24"
  map_public_ip_on_launch  = true
  availability_zone        = "us-west-2a"

  tags = {
    Name = "${var.service_name}-public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = "10.0.2.0/24"
  map_public_ip_on_launch  = true
  availability_zone        = "us-west-2b"

  tags = {
    Name = "${var.service_name}-public-2"
  }
}

###########################
# Private Subnets (for ECS)
###########################
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"

  tags = {
    Name = "${var.service_name}-private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2b"

  tags = {
    Name = "${var.service_name}-private-2"
  }
}



# Create a security group to allow HTTP to your container port
resource "aws_security_group" "this" {
  name        = "${var.service_name}-sg"
  description = "Allow inbound on ${var.container_port}"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
    description = "Allow HTTP traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }
}
