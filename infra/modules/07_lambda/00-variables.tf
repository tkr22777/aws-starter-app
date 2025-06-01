variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

variable "lambda_name" {
  type        = string
  description = "Name of the Lambda function"
  default     = "sqs-processor"
}

variable "queue_name" {
  type        = string
  description = "Name of the SQS queue to process (will be prefixed with app_name)"
  default     = "main-queue"
}

variable "lambda_timeout" {
  type        = number
  description = "The amount of time your Lambda Function has to run in seconds"
  default     = 30
}

variable "lambda_memory_size" {
  type        = number
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  default     = 128
}

variable "batch_size" {
  type        = number
  description = "The maximum number of items to retrieve in a single batch for the SQS event source"
  default     = 10
} 