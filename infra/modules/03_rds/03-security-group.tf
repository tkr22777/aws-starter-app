# Security group for the RDS instance
# This provides controlled access to the database instance
resource "aws_security_group" "rds_sg" {
  description = "Security Group for RDS"
  vpc_id      = local.vpc_id

  # Default - no ingress rules defined
  # Ingress rules will be defined as needed by EC2, ECS, or Lambda resources
  # through aws_security_group_rule resources to ensure modularity

  tags = {
    Name = "${var.app_name}-rds-sg"  # This tag is used by the EC2 module for automatic discovery
  }
} 