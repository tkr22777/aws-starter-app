# =============================================================================
# Data Sources
# =============================================================================

# Get VPC information
data "aws_vpc" "main" {
  count = var.vpc_id == "" ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-${var.environment}-vpc"]
  }
}

# Get ALB information
data "aws_lb" "main" {
  count = var.alb_arn == "" ? 1 : 0
  name  = "${var.app_name}-${var.environment}-alb"
}

# Get ALB listener
data "aws_lb_listener" "main" {
  count = var.alb_listener_arn == "" ? 1 : 0
  
  load_balancer_arn = var.alb_arn != "" ? var.alb_arn : data.aws_lb.main[0].arn
  port              = 80  # Assuming HTTP listener
}

# Get ECS cluster
data "aws_ecs_cluster" "main" {
  count = var.ecs_cluster_name == "" ? 1 : 0
  
  cluster_name = "${var.app_name}-${var.environment}-cluster"
}

# Get ECS service
data "aws_ecs_service" "main" {
  count = var.ecs_service_name == "" ? 1 : 0
  
  cluster_arn  = var.ecs_cluster_name != "" ? var.ecs_cluster_name : data.aws_ecs_cluster.main[0].arn
  service_name = "${var.app_name}-${var.environment}-service"
} 