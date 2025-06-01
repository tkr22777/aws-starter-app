# Security group for ECS tasks
resource "aws_security_group" "ecs_tasks_sg" {
  name_prefix = "${var.app_name}-ecs-tasks-"
  vpc_id      = data.aws_vpc.app_vpc.id
  description = "Security group for ECS tasks"

  # Allow traffic from ALB on container port
  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb_sg.id]
    description     = "Allow traffic from ALB"
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
    Name = "${var.app_name}-ecs-tasks-sg"
  }
} 