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
    cidr_blocks = ["0.0.0.0/0"] # Allows traffic from any IP address on the internet
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
    protocol    = "-1" # Protocol "-1" means all protocols (TCP, UDP, ICMP, etc.)
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
  internal           = var.internal # false = internet-facing (public), true = internal (private)
  load_balancer_type = "application" # Layer 7 load balancer - can route based on HTTP headers, paths, etc.
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.subnet_ids # Requires 2+ subnets in different AZs for high availability

  enable_deletion_protection = var.enable_deletion_protection # Prevents accidental deletion in production

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
  name        = "${substr(var.app_name, 0, 15)}-${var.environment}-def-tg" # Target group names limited to 32 chars
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip" # "ip" targets IP addresses, "instance" targets EC2 instance IDs

  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.healthy_threshold # Consecutive successful checks before marking healthy
    interval            = var.health_check_interval # Seconds between health checks
    matcher             = var.health_check_matcher # HTTP response codes considered healthy (e.g., "200,404")
    path                = var.health_check_path
    port                = "traffic-port" # Use same port as target group, not a fixed port
    protocol            = "HTTP"
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.unhealthy_threshold # Consecutive failed checks before marking unhealthy
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
    type = "fixed-response" # Returns static response without forwarding to targets

    fixed_response {
      content_type = "text/plain"
      message_body = "Service not found - ${var.app_name} ${var.environment}"
      status_code  = "404" # HTTP 404 for requests that don't match any listener rules
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