# Secret ARNs
output "secret_arns" {
  description = "ARNs of the created secrets"
  value = {
    for name, secret in aws_secretsmanager_secret.secrets : name => secret.arn
  }
}

# Secret names
output "secret_names" {
  description = "Names of the created secrets"
  value = {
    for name, secret in aws_secretsmanager_secret.secrets : name => secret.name
  }
}

# Secret IDs
output "secret_ids" {
  description = "IDs of the created secrets"
  value = {
    for name, secret in aws_secretsmanager_secret.secrets : name => secret.id
  }
}

# Individual secret outputs for easy reference
output "database_password_arn" {
  description = "ARN of the database password secret"
  value       = try(aws_secretsmanager_secret.secrets["database-password"].arn, null)
}

output "api_key_arn" {
  description = "ARN of the API key secret"
  value       = try(aws_secretsmanager_secret.secrets["api-key"].arn, null)
}

# Commands for retrieving secrets
output "retrieve_secret_commands" {
  description = "AWS CLI commands to retrieve secret values"
  value = {
    for name, secret in aws_secretsmanager_secret.secrets : name => 
    "aws secretsmanager get-secret-value --secret-id ${secret.name} --query SecretString --output text"
  }
}

# Commands for updating secrets
output "update_secret_commands" {
  description = "AWS CLI commands to update secret values"
  value = {
    for name, secret in aws_secretsmanager_secret.secrets : name => 
    "aws secretsmanager update-secret --secret-id ${secret.name} --secret-string 'your-new-secret-value'"
  }
}

# Region information
output "region" {
  description = "AWS region where secrets are created"
  value       = data.aws_region.current.name
}

# Account information
output "account_id" {
  description = "AWS account ID where secrets are created"
  value       = data.aws_caller_identity.current.account_id
} 