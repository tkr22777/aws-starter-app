# =============================================================================
# Lambda Module Configuration
# =============================================================================

module "lambda" {
  source = "../../../modules/07_lambda"
  
  # Application configuration
  app_name    = "the-awesome-app"
  environment = "prod"
  
  # Lambda configuration
  lambda_name        = "sqs-processor"
  lambda_timeout     = 30
  lambda_memory_size = 128
  
  # SQS integration - get from remote state
  sqs_queue_arn = data.terraform_remote_state.sqs.outputs.queue_arn
  sqs_queue_url = data.terraform_remote_state.sqs.outputs.queue_id
  dlq_arn       = data.terraform_remote_state.sqs.outputs.dlq_arn
  
  # Event source mapping configuration
  batch_size = 10
} 