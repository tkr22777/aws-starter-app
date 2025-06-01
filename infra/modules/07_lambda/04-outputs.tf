# =============================================================================
# Lambda Function Outputs
# =============================================================================

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.sqs_processor.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.sqs_processor.arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda IAM role"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_role_name" {
  description = "Name of the Lambda IAM role"
  value       = aws_iam_role.lambda_role.name
}

output "configured_sqs_queue_arn" {
  description = "ARN of the SQS queue configured for this Lambda (either provided or looked up)"
  value       = local.sqs_queue_arn
}

output "configured_sqs_queue_url" {
  description = "URL of the SQS queue configured for this Lambda (either provided or looked up)"
  value       = local.sqs_queue_url
}

output "configured_sqs_queue_name" {
  description = "Name of the SQS queue configured for this Lambda (either provided or looked up)"
  value       = local.sqs_queue_name
}

output "event_source_mapping_enabled" {
  description = "Whether the SQS event source mapping was created"
  value       = local.sqs_queue_arn != "" ? true : false
}

# =============================================================================
# Integration Outputs
# =============================================================================

output "event_source_mapping_id" {
  description = "ID of the event source mapping connecting SQS to the Lambda (if created)"
  value       = length(aws_lambda_event_source_mapping.sqs_trigger) > 0 ? aws_lambda_event_source_mapping.sqs_trigger[0].uuid : "Not created"
}

# =============================================================================
# CLI Examples
# =============================================================================

output "cli_invoke_example" {
  description = "Example CLI command to invoke the Lambda function directly"
  value       = "aws lambda invoke --function-name ${aws_lambda_function.sqs_processor.function_name} --payload '{\"test\": \"message\"}' response.json && cat response.json"
}

output "cli_logs_example" {
  description = "Example CLI command to view Lambda logs"
  value       = "aws logs tail /aws/lambda/${aws_lambda_function.sqs_processor.function_name} --follow"
}

output "cli_sqs_send_example" {
  description = "Example CLI command to send test message to configured SQS queue (if available)"
  value       = local.sqs_queue_url != "" ? "aws sqs send-message --queue-url ${local.sqs_queue_url} --message-body 'Test message from CLI'" : "No SQS queue configured"
}

output "cli_examples" {
  description = "AWS CLI commands for testing and managing the Lambda function"
  value       = <<-EOT
# View Lambda function logs
aws logs filter-log-events --log-group-name /aws/lambda/${aws_lambda_function.sqs_processor.function_name} --start-time $(date -d '1 hour ago' +%s)000 --region us-east-1

# Manually invoke the Lambda function
aws lambda invoke --function-name ${aws_lambda_function.sqs_processor.function_name} --payload '{"Records":[{"body":"{\"test\":\"Hello, Lambda!\"}"}]}' --cli-binary-format raw-in-base64-out output.json --region us-east-1

# Get Lambda function configuration
aws lambda get-function --function-name ${aws_lambda_function.sqs_processor.function_name} --region us-east-1

# List event source mappings
aws lambda list-event-source-mappings --function-name ${aws_lambda_function.sqs_processor.function_name} --region us-east-1

# Send test message to configured SQS queue (if available)
${local.sqs_queue_url != "" ? "aws sqs send-message --queue-url ${local.sqs_queue_url} --message-body 'Test message from CLI' --region us-east-1" : "# No SQS queue configured"}
  EOT
} 