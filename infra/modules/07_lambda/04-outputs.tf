output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.sqs_processor.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.sqs_processor.arn
}

output "lambda_role_arn" {
  description = "ARN of the IAM role used by the Lambda function"
  value       = aws_iam_role.lambda_role.arn
}

output "event_source_mapping_id" {
  description = "ID of the event source mapping connecting SQS to the Lambda"
  value       = aws_lambda_event_source_mapping.sqs_trigger.id
}

output "connected_queue_name" {
  description = "Name of the SQS queue connected to the Lambda"
  value       = data.aws_sqs_queue.target_queue.name
}

output "logs_command" {
  description = "Command to view Lambda function logs"
  value       = "aws logs filter-log-events --log-group-name /aws/lambda/${aws_lambda_function.sqs_processor.function_name} --start-time $(date -d '1 hour ago' +%s)000 --profile terraform_user"
}

output "invoke_command" {
  description = "Command to manually invoke the Lambda function"
  value       = "aws lambda invoke --function-name ${aws_lambda_function.sqs_processor.function_name} --payload '{\"Records\":[{\"body\":\"{\\\"test\\\":\\\"Hello, Lambda!\\\"}\"}]}' --cli-binary-format raw-in-base64-out output.json --profile terraform_user"
} 