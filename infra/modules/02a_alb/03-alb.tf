# Security group for Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name_prefix = "${var.app_name}-alb-"
  vpc_id      = data.aws_vpc.app_vpc.id
  description = "Security group for Application Load Balancer"

  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from internet"
  }

  # Allow HTTPS traffic from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from internet"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.app_name}-alb-sg"
  }
}

# Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [data.aws_subnet.main_subnet.id, data.aws_subnet.subnet_ha_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.app_name}-alb"
  }
}

# Default target group (for health checks)
resource "aws_lb_target_group" "default_tg" {
  name        = "${var.app_name}-default-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.app_vpc.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200,404"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.app_name}-default-tg"
  }
}

# Default listener for ALB (returns 404 for unmatched paths)
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    
    fixed_response {
      content_type = "text/plain"
      message_body = "Service not found"
      status_code  = "404"
    }
  }

  tags = {
    Name = "${var.app_name}-listener"
  }
} 