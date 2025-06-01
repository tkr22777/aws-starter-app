# =============================================================================
# Data Sources
# =============================================================================

# Current AWS region
data "aws_region" "current" {}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Get VPC (conditional lookup)
data "aws_vpc" "app_vpc" {
  count = var.vpc_id == "" ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-${var.environment}-vpc"]
  }
}

# Get main subnet
data "aws_subnet" "main_subnet" {
  count = var.subnet_id == "" ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-${var.environment}-subnet"]
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

# ECR Repository
data "aws_ecr_repository" "app_repo" {
  count = var.container_image == "" ? 1 : 0
  name  = "${var.app_name}-ecr-repo"
} 