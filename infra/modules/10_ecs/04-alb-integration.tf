# ECS Target group for ALB
resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.app_name}-ecs-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.app_vpc.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.app_name}-ecs-tg"
  }
}

# Listener rule for ECS service path routing
resource "aws_lb_listener_rule" "ecs_rule" {
  listener_arn = data.aws_lb_listener.app_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }

  condition {
    path_pattern {
      values = [var.api_path_prefix]
    }
  }

  tags = {
    Name = "${var.app_name}-ecs-rule"
  }
} 