# Security group rule allowing EC2 to connect to RDS on PostgreSQL port
resource "aws_security_group_rule" "ec2_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = local.rds_sg_id
  source_security_group_id = local.ec2_sg_id
  
  description = "Allow PostgreSQL connections from EC2 instances"
}

# Outputs for reference
output "ec2_sg_id" {
  description = "The ID of the EC2 security group"
  value       = local.ec2_sg_id
}

output "rds_sg_id" {
  description = "The ID of the RDS security group"
  value       = local.rds_sg_id
}

output "rule_id" {
  description = "The ID of the security group rule"
  value       = aws_security_group_rule.ec2_to_rds.id
} 