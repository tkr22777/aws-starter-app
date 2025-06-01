module "sqs" {
  source = "../../../modules/06_sqs"

  app_name                   = var.app_name
  environment                = var.environment
  queue_name                 = var.queue_name
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  create_dlq                 = var.create_dlq
  dlq_max_receive_count      = var.dlq_max_receive_count
} 