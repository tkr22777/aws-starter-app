# S3 Service User Outputs
output "s3_service_user_name" {
  description = "Name of the S3 service user"
  value       = var.create_s3_user ? aws_iam_user.s3_service_user[0].name : null
}

output "s3_service_user_arn" {
  description = "ARN of the S3 service user"
  value       = var.create_s3_user ? aws_iam_user.s3_service_user[0].arn : null
}

output "s3_service_access_key_id" {
  description = "Access key ID for the S3 service user"
  value       = var.create_s3_user ? aws_iam_access_key.s3_service_access_key[0].id : null
}

output "s3_service_secret_access_key" {
  description = "Secret access key for the S3 service user"
  value       = var.create_s3_user ? aws_iam_access_key.s3_service_access_key[0].secret : null
  sensitive   = true
}

# SQS Service User Outputs
output "sqs_service_user_name" {
  description = "Name of the SQS service user"
  value       = var.create_sqs_user ? aws_iam_user.sqs_service_user[0].name : null
}

output "sqs_service_user_arn" {
  description = "ARN of the SQS service user"
  value       = var.create_sqs_user ? aws_iam_user.sqs_service_user[0].arn : null
}

output "sqs_service_access_key_id" {
  description = "Access key ID for the SQS service user"
  value       = var.create_sqs_user ? aws_iam_access_key.sqs_service_access_key[0].id : null
}

output "sqs_service_secret_access_key" {
  description = "Secret access key for the SQS service user"
  value       = var.create_sqs_user ? aws_iam_access_key.sqs_service_access_key[0].secret : null
  sensitive   = true
}

# DynamoDB Service User Outputs
output "dynamodb_service_user_name" {
  description = "Name of the DynamoDB service user"
  value       = var.create_dynamodb_user ? aws_iam_user.dynamodb_service_user[0].name : null
}

output "dynamodb_service_user_arn" {
  description = "ARN of the DynamoDB service user"
  value       = var.create_dynamodb_user ? aws_iam_user.dynamodb_service_user[0].arn : null
}

output "dynamodb_service_access_key_id" {
  description = "Access key ID for the DynamoDB service user"
  value       = var.create_dynamodb_user ? aws_iam_access_key.dynamodb_service_access_key[0].id : null
}

output "dynamodb_service_secret_access_key" {
  description = "Secret access key for the DynamoDB service user"
  value       = var.create_dynamodb_user ? aws_iam_access_key.dynamodb_service_access_key[0].secret : null
  sensitive   = true
}

# RDS Service User Outputs
output "rds_service_user_name" {
  description = "Name of the RDS service user"
  value       = var.create_rds_user ? aws_iam_user.rds_service_user[0].name : null
}

output "rds_service_user_arn" {
  description = "ARN of the RDS service user"
  value       = var.create_rds_user ? aws_iam_user.rds_service_user[0].arn : null
}

output "rds_service_access_key_id" {
  description = "Access key ID for the RDS service user"
  value       = var.create_rds_user ? aws_iam_access_key.rds_service_access_key[0].id : null
}

output "rds_service_secret_access_key" {
  description = "Secret access key for the RDS service user"
  value       = var.create_rds_user ? aws_iam_access_key.rds_service_access_key[0].secret : null
  sensitive   = true
}

# Combined Service User Outputs
output "combined_service_user_name" {
  description = "Name of the combined service user"
  value       = var.create_combined_user ? aws_iam_user.combined_service_user[0].name : null
}

output "combined_service_user_arn" {
  description = "ARN of the combined service user"
  value       = var.create_combined_user ? aws_iam_user.combined_service_user[0].arn : null
}

output "combined_service_access_key_id" {
  description = "Access key ID for the combined service user"
  value       = var.create_combined_user ? aws_iam_access_key.combined_service_access_key[0].id : null
}

output "combined_service_secret_access_key" {
  description = "Secret access key for the combined service user"
  value       = var.create_combined_user ? aws_iam_access_key.combined_service_access_key[0].secret : null
  sensitive   = true
}

# Reference Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = var.create_s3_user ? "${var.app_name}-${var.s3_bucket_name}" : null
}

output "sqs_queue_name" {
  description = "Name of the SQS queue"
  value       = var.create_sqs_user ? "${var.app_name}-${var.sqs_queue_name}" : null
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = var.create_dynamodb_user ? "${var.app_name}-${var.dynamodb_table_name}" : null
}

output "rds_instance_identifier" {
  description = "Identifier of the RDS instance"
  value       = var.create_rds_user ? "${var.app_name}-${var.db_identifier}" : null
} 