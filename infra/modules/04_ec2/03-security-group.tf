# Security group for EC2 instances 
resource "aws_security_group" "ec2_sg" {
  name        = "${var.app_name}-${var.environment}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = local.vpc_id

  tags = {
    Name = "${var.app_name}-${var.environment}-ec2-sg"
  }
}

# SSH access rule (conditional)
resource "aws_security_group_rule" "ssh_access" {
  count             = var.enable_ssh_access ? 1 : 0
  type              = "ingress"
  description       = "SSH access"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_ssh_cidr]
  security_group_id = aws_security_group.ec2_sg.id
}

# Allow all outbound traffic
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  description       = "All outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
} 