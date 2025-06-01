# EC2 Target group for ALB
resource "aws_lb_target_group" "ec2_tg" {
  name        = local.target_group_name
  port        = var.ec2_instance_port
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "instance"

  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.healthy_threshold
    interval            = var.health_check_interval
    matcher             = "200"
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = {
    Name = local.target_group_name
  }
}

# Register EC2 instance with target group
resource "aws_lb_target_group_attachment" "ec2_attachment" {
  target_group_arn = aws_lb_target_group.ec2_tg.arn
  target_id        = var.ec2_instance_id
  port             = var.ec2_instance_port
} 