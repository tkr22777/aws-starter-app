# =============================================================================
# EC2-RDS Integration Outputs
# =============================================================================

output "ec2_security_group_id" {
  description = "The ID of the EC2 security group used for connectivity"
  value       = module.ec2_rds.ec2_sg_id
}

output "rds_security_group_id" {
  description = "The ID of the RDS security group used for connectivity"
  value       = module.ec2_rds.rds_sg_id
}

output "connectivity_rule_id" {
  description = "The ID of the security group rule enabling EC2-RDS connectivity"
  value       = module.ec2_rds.rule_id
} 