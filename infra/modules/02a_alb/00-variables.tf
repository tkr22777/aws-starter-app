# =============================================================================
# Application Configuration
# =============================================================================
variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "the-awesome-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

# =============================================================================
# Network Configuration
# =============================================================================
variable "vpc_id" {
  description = "VPC ID where ALB will be deployed. If empty, will lookup using app_name and environment"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB. If empty, will lookup using app_name and environment"
  type        = list(string)
  default     = []
}

# =============================================================================
# ALB Configuration
# =============================================================================
variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

variable "internal" {
  description = "Whether the ALB is internal or internet-facing"
  type        = bool
  default     = false
}

# =============================================================================
# Health Check Configuration
# =============================================================================
variable "health_check_enabled" {
  description = "Enable health checks for default target group"
  type        = bool
  default     = true
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of consecutive successful health checks"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed health checks"
  type        = number
  default     = 2
}

variable "health_check_matcher" {
  description = "HTTP status codes for successful health checks"
  type        = string
  default     = "200,404"
} 