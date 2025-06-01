# =============================================================================
# Lambda Function Outputs
# =============================================================================

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = module.lambda.lambda_function_name
}

output "lambda_function_arn" {
  description = "ARN of the deployed Lambda function"
  value       = module.lambda.lambda_function_arn
}

output "configured_sqs_queue_arn" {
  description = "ARN of the SQS queue configured for this Lambda"
  value       = module.lambda.configured_sqs_queue_arn
}

output "event_source_mapping_enabled" {
  description = "Whether the SQS event source mapping was created"
  value       = module.lambda.event_source_mapping_enabled
}

# =============================================================================
# CLI Examples
# =============================================================================

output "cli_invoke_example" {
  description = "CLI command to test the Lambda function"
  value       = module.lambda.cli_invoke_example
}

output "cli_logs_example" {
  description = "CLI command to view Lambda logs"
  value       = module.lambda.cli_logs_example
}

output "cli_sqs_send_example" {
  description = "CLI command to send test message to SQS"
  value       = module.lambda.cli_sqs_send_example
} 