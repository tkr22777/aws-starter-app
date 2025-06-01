# =============================================================================
# Application Configuration
# =============================================================================

variable "app_name" {
  description = "Name of the application for tagging and resource naming."
  type        = string
  default     = "the-awesome-app-prod"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "prod"
}

# =============================================================================
# EC2 Integration Configuration
# =============================================================================

variable "ec2_instance_port" {
  description = "Port on which the EC2 instance is listening."
  type        = number
  default     = 80
}

# =============================================================================
# ALB Configuration
# =============================================================================

variable "api_path_prefix" {
  description = "Path prefix for API routing."
  type        = string
  default     = "/api/*"
}

variable "listener_rule_priority" {
  description = "Priority for the ALB listener rule (1-50000)."
  type        = number
  default     = 200
}

# =============================================================================
# Health Check Configuration
# =============================================================================

variable "health_check_enabled" {
  description = "Whether to enable health checks for the target group."
  type        = bool
  default     = true
}

variable "health_check_path" {
  description = "Health check path."
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Health check interval in seconds."
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds."
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of consecutive successful health checks required."
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed health checks required."
  type        = number
  default     = 2
} 