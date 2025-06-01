# =============================================================================
# Application Configuration
# =============================================================================

variable "app_name" {
  description = "Name of the application for tagging and resource naming"
  type        = string
  default     = "the-awesome-app"
}

variable "environment" {
  description = "Environment name (prod, staging, dev)"
  type        = string
  default     = "prod"
}

# =============================================================================
# Lambda Function Configuration
# =============================================================================

variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "sqs-processor"
}

variable "lambda_timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 128
}

# =============================================================================
# SQS Integration Configuration
# =============================================================================

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue to process messages from (if not provided, will lookup by name)"
  type        = string
  default     = ""
}

variable "sqs_queue_url" {
  description = "URL of the SQS queue to process messages from (if not provided, will lookup by name)"
  type        = string
  default     = ""
}

variable "sqs_queue_name" {
  description = "Name of the SQS queue to lookup (only used if sqs_queue_arn is not provided)"
  type        = string
  default     = ""
}

variable "dlq_arn" {
  description = "ARN of the dead letter queue (optional)"
  type        = string
  default     = ""
}

variable "batch_size" {
  description = "The maximum number of items to retrieve in a single batch for the SQS event source"
  type        = number
  default     = 10
} 