# Security group for ECS tasks
resource "aws_security_group" "ecs_tasks_sg" {
  name_prefix = "${var.app_name}-${var.environment}-ecs-tasks-"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.app_vpc[0].id
  description = "Security group for ECS tasks"

  # Allow traffic on container port from VPC CIDR
  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_id == "" ? data.aws_vpc.app_vpc[0].cidr_block : "10.0.0.0/16"]  # Use lookup or default
    description = "Allow traffic on container port"
  }

  # Allow all outbound traffic (for pulling images, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-ecs-tasks-sg"
    Environment = var.environment
    Project     = var.app_name
    Module      = "10_ecs"
    ManagedBy   = "terraform"
  }
} 