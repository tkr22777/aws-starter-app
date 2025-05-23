# EC2 Target group for ALB
resource "aws_lb_target_group" "ec2_tg" {
  name        = "${var.app_name}-ec2-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.app_vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.app_name}-ec2-tg"
  }
}

# Register EC2 instance with target group
resource "aws_lb_target_group_attachment" "ec2_attachment" {
  target_group_arn = aws_lb_target_group.ec2_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 80
}

# Listener rule for EC2 service path routing
resource "aws_lb_listener_rule" "ec2_rule" {
  listener_arn = data.aws_lb_listener.app_listener.arn
  priority     = 200

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
    Name = "${var.app_name}-ec2-rule"
  }
} 