# =============================================================================
# Database Outputs
# =============================================================================

output "db_endpoint" {
  description = "The connection endpoint for the production database."
  value       = module.rds.db_endpoint
}

output "db_connection_string" {
  description = "The connection string for the production database."
  value       = module.rds.db_connection_string
  sensitive   = true
}

output "db_instance_id" {
  description = "The ID of the production database instance."
  value       = module.rds.db_instance_id
}

output "db_subnet_group_name" {
  description = "The name of the production database subnet group."
  value       = module.rds.db_subnet_group_name
}

# =============================================================================
# Security Group Outputs
# =============================================================================

output "rds_security_group_id" {
  description = "The ID of the production RDS security group."
  value       = module.rds.rds_security_group_id
}

# =============================================================================
# Usage Examples
# =============================================================================

# Example AWS CLI commands for production database verification:
# aws rds describe-db-instances --db-instance-identifier $(terraform output -raw db_instance_id)
# aws ec2 describe-security-groups --group-ids $(terraform output -raw rds_security_group_id)
# aws rds describe-db-subnet-groups --db-subnet-group-name $(terraform output -raw db_subnet_group_name)
# 
# Database connection test:
# $(terraform output -raw db_connection_string) 