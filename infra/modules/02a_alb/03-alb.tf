# =============================================================================
# Security Group for Application Load Balancer
# =============================================================================
resource "aws_security_group" "alb_sg" {
  name_prefix = "${var.app_name}-${var.environment}-alb-"
  vpc_id      = local.vpc_id
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
    Name        = "${var.app_name}-${var.environment}-alb-sg"
    Environment = var.environment
    Project     = var.app_name
    Module      = "02a_alb"
    ManagedBy   = "terraform"
  }
}

# =============================================================================
# Application Load Balancer
# =============================================================================
resource "aws_lb" "app_alb" {
  name               = "${var.app_name}-${var.environment}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name        = "${var.app_name}-${var.environment}-alb"
    Environment = var.environment
    Project     = var.app_name
    Module      = "02a_alb"
    ManagedBy   = "terraform"
  }
}

# =============================================================================
# Default Target Group (for health checks)
# =============================================================================
resource "aws_lb_target_group" "default_tg" {
  name        = "${substr(var.app_name, 0, 15)}-${var.environment}-def-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip"

  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.healthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-default-tg"
    Environment = var.environment
    Project     = var.app_name
    Module      = "02a_alb"
    ManagedBy   = "terraform"
  }
}

# =============================================================================
# Default Listener for ALB (returns 404 for unmatched paths)
# =============================================================================
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Service not found - ${var.app_name} ${var.environment}"
      status_code  = "404"
    }
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-listener"
    Environment = var.environment
    Project     = var.app_name
    Module      = "02a_alb"
    ManagedBy   = "terraform"
  }
} 