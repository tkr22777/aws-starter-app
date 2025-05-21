# Security group for EC2 instances 
resource "aws_security_group" "ec2_sg" {
  description = "Security Group for EC2"
  vpc_id      = data.aws_vpc.app_vpc.id

  # SSH access from specified CIDR
  ingress {
    description = "SSH"
    cidr_blocks = [var.allowed_ssh_cidr]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # HTTP access from anywhere
  ingress {
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # HTTPS access from anywhere
  ingress {
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  # Outbound access to anywhere
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "${var.app_name}-ec2-sg"
  }
} 