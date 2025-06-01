# =============================================================================
# Database Core Outputs
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

output "db_instance_arn" {
  description = "The ARN of the database instance"
  value       = aws_db_instance.database.arn
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

output "rds_security_group_arn" {
  description = "The ARN of the RDS security group"
  value       = aws_security_group.rds_sg.arn
}

# =============================================================================
# CLI Examples
# =============================================================================

output "cli_examples" {
  description = "Useful AWS CLI commands for RDS management"
  value       = <<-EOT
# Check database status
aws rds describe-db-instances --db-instance-identifier ${aws_db_instance.database.id} --region us-east-1

# View database logs
aws rds describe-db-log-files --db-instance-identifier ${aws_db_instance.database.id} --region us-east-1

# Create database snapshot
aws rds create-db-snapshot --db-instance-identifier ${aws_db_instance.database.id} --db-snapshot-identifier ${aws_db_instance.database.id}-$(date +%Y%m%d-%H%M%S) --region us-east-1

# Check security group rules
aws ec2 describe-security-groups --group-ids ${aws_security_group.rds_sg.id} --region us-east-1

# Test database connectivity (from EC2)
psql -h ${split(":", aws_db_instance.database.endpoint)[0]} -p 5432 -U postgres -d postgres
  EOT
}

# =============================================================================
# Integration Values
# =============================================================================

output "integration" {
  description = "Values commonly needed by other modules for RDS integration"
  value = {
    db_endpoint         = aws_db_instance.database.endpoint
    db_port             = aws_db_instance.database.port
    security_group_id   = aws_security_group.rds_sg.id
    subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
    instance_identifier = aws_db_instance.database.id
  }
} 