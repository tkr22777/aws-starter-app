output "kms_key_ids" {
  description = "Map of KMS key IDs"
  value       = { for k, v in aws_kms_key.keys : k => v.key_id }
}

output "kms_key_arns" {
  description = "Map of KMS key ARNs"
  value       = { for k, v in aws_kms_key.keys : k => v.arn }
}

output "kms_aliases" {
  description = "Map of KMS alias names"
  value       = { for k, v in aws_kms_alias.aliases : k => v.name }
}

output "kms_alias_arns" {
  description = "Map of KMS alias ARNs"
  value       = { for k, v in aws_kms_alias.aliases : k => v.arn }
}

# Useful outputs for integration with other modules
output "general_key_id" {
  description = "General purpose KMS key ID"
  value       = try(aws_kms_key.keys["general"].key_id, null)
}

output "general_key_arn" {
  description = "General purpose KMS key ARN"
  value       = try(aws_kms_key.keys["general"].arn, null)
}

output "s3_key_id" {
  description = "S3 KMS key ID"
  value       = try(aws_kms_key.keys["s3"].key_id, null)
}

output "s3_key_arn" {
  description = "S3 KMS key ARN"
  value       = try(aws_kms_key.keys["s3"].arn, null)
}

output "database_key_id" {
  description = "Database KMS key ID"
  value       = try(aws_kms_key.keys["database"].key_id, null)
}

output "database_key_arn" {
  description = "Database KMS key ARN"
  value       = try(aws_kms_key.keys["database"].arn, null)
}

output "secrets_key_id" {
  description = "Secrets KMS key ID"
  value       = try(aws_kms_key.keys["secrets"].key_id, null)
}

output "secrets_key_arn" {
  description = "Secrets KMS key ARN"
  value       = try(aws_kms_key.keys["secrets"].arn, null)
}

# CLI commands
output "aws_cli_commands" {
  description = "Useful AWS CLI commands for KMS"
  value = {
    list_keys = "aws kms list-keys"
    list_aliases = "aws kms list-aliases"
    describe_general_key = try("aws kms describe-key --key-id ${aws_kms_key.keys["general"].key_id}", "General key not created")
    encrypt_example = try("aws kms encrypt --key-id ${aws_kms_key.keys["general"].key_id} --plaintext 'Hello World' --output text --query CiphertextBlob", "General key not created")
  }
}

# Account and region info
output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "region" {
  description = "AWS Region"
  value       = data.aws_region.current.name
} 