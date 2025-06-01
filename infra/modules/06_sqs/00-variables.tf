variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

variable "queue_name" {
  type        = string
  description = "Name of the SQS queue (will be prefixed with app_name)"
  default     = "main-queue"
}

variable "message_retention_seconds" {
  type        = number
  description = "The number of seconds Amazon SQS retains a message"
  default     = 345600  # 4 days
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "The visibility timeout for the queue"
  default     = 30
}

variable "create_dlq" {
  type        = bool
  description = "Whether to create a dead letter queue"
  default     = true
}

variable "dlq_max_receive_count" {
  type        = number
  description = "Maximum number of receives before message is sent to the dead letter queue"
  default     = 5
} 