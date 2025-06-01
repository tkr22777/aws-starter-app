# =============================================================================
# SQS Outputs
# =============================================================================

output "queue_id" {
  description = "The URL of the SQS queue"
  value       = module.sqs.queue_id
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = module.sqs.queue_arn
}

output "queue_name" {
  description = "The name of the SQS queue"
  value       = module.sqs.queue_name
}

output "dlq_id" {
  description = "The URL of the dead-letter queue (if created)"
  value       = module.sqs.dlq_id
}

output "dlq_arn" {
  description = "The ARN of the dead-letter queue (if created)"
  value       = module.sqs.dlq_arn
}

output "dlq_name" {
  description = "The name of the dead-letter queue (if created)"
  value       = module.sqs.dlq_name
}

output "sqs_integration" {
  description = "Integration object for use in other modules"
  value       = module.sqs.sqs_integration
}

output "cli_examples" {
  description = "AWS CLI commands for testing and managing the SQS queue"
  value       = module.sqs.cli_examples
} 