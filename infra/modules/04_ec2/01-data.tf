# Get VPC info from the network module
data "aws_vpc" "app_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-vpc"]
  }
}

# Get subnet info from the network module - lookup by tags
data "aws_subnet" "app_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-vpc-subnet"]
  }
}

# Get ALB security group for integration
data "aws_security_group" "alb_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-alb-sg"]
  }
}

# Get ALB for target group attachment
data "aws_lb" "app_alb" {
  name = "${var.app_name}-alb"
}

# Get ALB listener for routing rules
data "aws_lb_listener" "app_listener" {
  load_balancer_arn = data.aws_lb.app_alb.arn
  port              = 80
}

# Get ECS-optimized Amazon Linux 2023 AMI (has Docker pre-installed)
data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
} 