# =============================================================================
# Database Outputs
# =============================================================================

output "db_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.database.endpoint
}

output "db_connection_string" {
  description = "The connection string for the database"
  value       = "psql -h ${split(":", aws_db_instance.database.endpoint)[0]} -p 5432 -U postgres -d postgres"
}

output "db_instance_id" {
  description = "The ID of the database instance"
  value       = aws_db_instance.database.id
}

output "db_subnet_group_name" {
  description = "The name of the database subnet group"
  value       = aws_db_subnet_group.rds_subnet_group.name
}

# =============================================================================
# Security Group Outputs
# =============================================================================

output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds_sg.id
}

# =============================================================================
# CLI Examples
# =============================================================================

# Example AWS CLI commands for verification:
# aws rds describe-db-instances --db-instance-identifier <db_instance_id>
# aws ec2 describe-security-groups --group-ids <rds_security_group_id>
# aws rds describe-db-subnet-groups --db-subnet-group-name <db_subnet_group_name> 