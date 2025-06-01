# Data sources to lookup existing infrastructure
data "aws_vpc" "app_vpc" {
  tags = {
    Name = "${var.app_name}-vpc"
  }
}

data "aws_subnet" "main_subnet" {
  tags = {
    Name = "${var.app_name}-vpc-subnet"
  }
}

data "aws_subnet" "subnet_ha_2" {
  tags = {
    Name = "${var.app_name}-subnet-2-ha"
  }
}

data "aws_lb" "app_alb" {
  tags = {
    Name = "${var.app_name}-alb"
  }
}

data "aws_lb_listener" "app_listener" {
  load_balancer_arn = data.aws_lb.app_alb.arn
  port              = 80
}

data "aws_security_group" "alb_sg" {
  tags = {
    Name = "${var.app_name}-alb-sg"
  }
}

data "aws_ecr_repository" "app_repo" {
  name = "${var.app_name}-ecr"
}

# Get current AWS region and account ID
data "aws_region" "current" {}
data "aws_caller_identity" "current" {} 