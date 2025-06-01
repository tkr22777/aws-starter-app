data "aws_sqs_queue" "target_queue" {
  name = "${var.app_name}-${var.queue_name}"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {} 