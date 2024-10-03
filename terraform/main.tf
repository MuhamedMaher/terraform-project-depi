provider "aws" {
  region = "us-east-1"  # Change as needed
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "MyVPC"
  }
}

# Create Subnets
resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidrs[0]
  availability_zone = "us-east-1a"  # Change as needed
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnetA"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidrs[1]
  availability_zone = "us-east-1b"  # Change as needed
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnetB"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidrs[0]
  availability_zone = "us-east-1a"  # Change as needed
  tags = {
    Name = "PrivateSubnetA"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidrs[1]
  availability_zone = "us-east-1b"  # Change as needed
  tags = {
    Name = "PrivateSubnetB"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "MyInternetGateway"
  }
}

# Create a route table for public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

# Create Auto Scaling Group
resource "aws_launch_configuration" "lc" {
  name          = "my_launch_configuration"
  image_id     = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "AutoScalingInstance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.lc.id
  vpc_zone_identifier = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2

  tag {
    key                 = "Name"
    value               = "AutoScalingGroupInstance"
    propagate_at_launch = true
  }
}

# Create a Load Balancer
resource "aws_elb" "lb" {
  name               = "my-load-balancer"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port          = 80
    lb_protocol      = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "MyLoadBalancer"
  }
}

# Attach Load Balancer to Auto Scaling Group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  elb                    = aws_elb.lb.id
}

