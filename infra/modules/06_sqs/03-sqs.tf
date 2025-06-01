# Dead Letter Queue for failed messages
resource "aws_sqs_queue" "dead_letter_queue" {
  count = var.create_dlq ? 1 : 0

  name                       = "${var.app_name}-${var.environment}-${var.queue_name}-dlq"
  delay_seconds              = 0
  max_message_size           = 262144 # 256 KiB
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = var.visibility_timeout_seconds

  tags = {
    Name = "${var.app_name}-${var.environment}-${var.queue_name}-dlq"
  }
}

# Main SQS Queue
resource "aws_sqs_queue" "main" {
  name                       = "${var.app_name}-${var.environment}-${var.queue_name}"
  delay_seconds              = 0
  max_message_size           = 262144 # 256 KiB
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = var.visibility_timeout_seconds

  # Dead letter queue configuration - use conditional for the redrive policy
  redrive_policy = var.create_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue[0].arn
    maxReceiveCount     = var.dlq_max_receive_count
  }) : null

  tags = {
    Name = "${var.app_name}-${var.environment}-${var.queue_name}"
  }
}

# SQS Queue Policy
resource "aws_sqs_queue_policy" "main" {
  queue_url = aws_sqs_queue.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${var.app_name}-${var.environment}-${var.queue_name}-policy"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*" # This allows resources in the same AWS account to use the queue
        }
        Action   = "sqs:*"
        Resource = aws_sqs_queue.main.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:*:*:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      }
    ]
  })
}

# Optional DLQ policy
resource "aws_sqs_queue_policy" "dlq" {
  count     = var.create_dlq ? 1 : 0
  queue_url = aws_sqs_queue.dead_letter_queue[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${var.app_name}-${var.environment}-${var.queue_name}-dlq-policy"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "sqs:*"
        Resource = aws_sqs_queue.dead_letter_queue[0].arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:*:*:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      }
    ]
  })
} 