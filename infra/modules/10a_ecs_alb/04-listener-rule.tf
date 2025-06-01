# =============================================================================
# ALB Listener Rule for ECS Service
# =============================================================================

resource "aws_lb_listener_rule" "ecs" {
  listener_arn = var.alb_listener_arn != "" ? var.alb_listener_arn : data.aws_lb_listener.main[0].arn
  priority     = var.listener_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }

  # Path-based routing condition
  condition {
    path_pattern {
      values = [var.path_pattern]
    }
  }

  # Optional host header condition
  dynamic "condition" {
    for_each = var.host_header != "" ? [1] : []
    content {
      host_header {
        values = [var.host_header]
      }
    }
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-ecs-rule"
    Environment = var.environment
    Project     = var.app_name
    Module      = "10a_ecs_alb"
    ManagedBy   = "terraform"
  }
} 