# Conditional SQS queue lookup - only if ARN not provided directly
data "aws_sqs_queue" "target_queue" {
  count = var.sqs_queue_arn == "" && var.sqs_queue_name != "" ? 1 : 0
  name  = var.sqs_queue_name
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {} 