# =============================================================================
# Application Configuration
# =============================================================================

variable "app_name" {
  description = "Name of the application for tagging and resource naming"
  type        = string
  default     = "the-awesome-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

# =============================================================================
# SQS Queue Configuration
# =============================================================================

variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
  default     = "main-queue"
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message"
  type        = number
  default     = 345600 # 4 days
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue"
  type        = number
  default     = 30
}

# =============================================================================
# Dead Letter Queue Configuration
# =============================================================================

variable "create_dlq" {
  description = "Whether to create a dead letter queue"
  type        = bool
  default     = true
}

variable "dlq_max_receive_count" {
  description = "Maximum number of receives before message is sent to the dead letter queue"
  type        = number
  default     = 5
} 