# Conditional data sources - only used if explicit values not provided
data "aws_vpc" "app_vpc" {
  count = var.vpc_id == "" ? 1 : 0
  
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-vpc"]
  }
  
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

# Get ALB for listener discovery (conditional)
data "aws_lb" "app_alb" {
  count = var.alb_listener_arn == "" ? 1 : 0
  name  = "${var.app_name}-alb"
}

# Get ALB listener for routing rules (conditional)
data "aws_lb_listener" "app_listener" {
  count             = var.alb_listener_arn == "" ? 1 : 0
  load_balancer_arn = data.aws_lb.app_alb[0].arn
  port              = 80
}

# Locals to handle both explicit values and data source discovery
locals {
  vpc_id           = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.app_vpc[0].id
  alb_listener_arn = var.alb_listener_arn != "" ? var.alb_listener_arn : data.aws_lb_listener.app_listener[0].arn
  
  # Target group name logic
  target_group_name = var.target_group_name_override != "" ? var.target_group_name_override : "${var.app_name}-${var.environment}-ec2-tg"
} 