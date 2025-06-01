# =============================================================================
# Target Group for ECS Service
# =============================================================================

resource "aws_lb_target_group" "ecs" {
  name        = "${var.app_name}-${var.environment}-ecs-tg"
  port        = var.container_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.main[0].id
  target_type = "ip"

  # Health check configuration
  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.healthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = var.target_group_protocol
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.unhealthy_threshold
  }

  # Target group attributes
  deregistration_delay = var.deregistration_delay

  tags = {
    Name        = "${var.app_name}-${var.environment}-ecs-tg"
    Environment = var.environment
    Project     = var.app_name
    Module      = "10a_ecs_alb"
    ManagedBy   = "terraform"
  }
} 