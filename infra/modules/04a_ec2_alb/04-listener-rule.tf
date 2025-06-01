# Listener rule for EC2 service path routing
resource "aws_lb_listener_rule" "ec2_rule" {
  listener_arn = local.alb_listener_arn
  priority     = var.listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_tg.arn
  }

  condition {
    path_pattern {
      values = [var.api_path_prefix]
    }
  }

  tags = {
    Name = "${var.app_name}-${var.environment}-ec2-rule"
  }
} 