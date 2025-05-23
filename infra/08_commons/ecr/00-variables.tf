# =============================================================================
# Application Configuration
# =============================================================================

variable "app_name" {
  description = "Application name for resource naming"
  type        = string
  default     = "the-awesome-app"
}

variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
  default     = "development"
}

# =============================================================================
# ECR Configuration
# =============================================================================

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

# =============================================================================
# Tagging Configuration
# =============================================================================

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
} 