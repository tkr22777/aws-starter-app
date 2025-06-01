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