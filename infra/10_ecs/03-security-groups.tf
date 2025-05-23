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