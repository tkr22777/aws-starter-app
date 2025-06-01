# =============================================================================
# SQS Queue Outputs
# =============================================================================

output "queue_id" {
  description = "The URL of the SQS queue"
  value       = aws_sqs_queue.main.id
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = aws_sqs_queue.main.arn
}

output "queue_name" {
  description = "The name of the SQS queue"
  value       = aws_sqs_queue.main.name
}

# =============================================================================
# Dead Letter Queue Outputs
# =============================================================================

output "dlq_id" {
  description = "The URL of the dead-letter queue (if created)"
  value       = var.create_dlq ? aws_sqs_queue.dead_letter_queue[0].id : null
}

output "dlq_arn" {
  description = "The ARN of the dead-letter queue (if created)"
  value       = var.create_dlq ? aws_sqs_queue.dead_letter_queue[0].arn : null
}

output "dlq_name" {
  description = "The name of the dead-letter queue (if created)"
  value       = var.create_dlq ? aws_sqs_queue.dead_letter_queue[0].name : null
}

# =============================================================================
# Integration Object for Other Modules
# =============================================================================

output "sqs_integration" {
  description = "Integration object for use in other modules"
  value = {
    queue_arn  = aws_sqs_queue.main.arn
    queue_url  = aws_sqs_queue.main.id
    queue_name = aws_sqs_queue.main.name
    dlq_arn    = var.create_dlq ? aws_sqs_queue.dead_letter_queue[0].arn : null
    dlq_url    = var.create_dlq ? aws_sqs_queue.dead_letter_queue[0].id : null
    dlq_name   = var.create_dlq ? aws_sqs_queue.dead_letter_queue[0].name : null
  }
}

# =============================================================================
# CLI Examples
# =============================================================================

output "cli_examples" {
  description = "AWS CLI commands for testing and managing the SQS queue"
  value       = <<-EOT
# Send a message to the queue
aws sqs send-message --queue-url ${aws_sqs_queue.main.id} --message-body "Hello from SQS" --region us-east-1

# Receive messages from the queue
aws sqs receive-message --queue-url ${aws_sqs_queue.main.id} --max-number-of-messages 10 --region us-east-1

# Get queue attributes
aws sqs get-queue-attributes --queue-url ${aws_sqs_queue.main.id} --attribute-names All --region us-east-1

# Purge the queue (delete all messages)
aws sqs purge-queue --queue-url ${aws_sqs_queue.main.id} --region us-east-1

${var.create_dlq ? "# Check dead letter queue\naws sqs receive-message --queue-url ${aws_sqs_queue.dead_letter_queue[0].id} --region us-east-1" : ""}
  EOT
} 