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
# AWS Configuration
# =============================================================================
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

# =============================================================================
# ALB Configuration
# =============================================================================
variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = true # Enable for production
}

variable "internal" {
  description = "Whether the ALB is internal or internet-facing"
  type        = bool
  default     = false # Internet-facing for production
} 