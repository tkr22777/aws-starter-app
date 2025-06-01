# =============================================================================
# Application Configuration
# =============================================================================

variable "app_name" {
  description = "Name of the application for tagging and resource naming."
  type        = string
  default     = "the-awesome-app"
}

variable "environment" {
  description = "Deployment environment (e.g., prod, dev, staging)."
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "The AWS region where resources will be deployed."
  type        = string
  default     = "us-east-1"
}

# =============================================================================
# Database Configuration
# =============================================================================

variable "db_password" {
  description = "Password for the production RDS database instance."
  type        = string
  sensitive   = true
  default     = "ProdPassword123!" # TODO: Use AWS Secrets Manager for production
}

# =============================================================================
# Network Configuration (Optional - uses remote state if not provided)
# =============================================================================

variable "vpc_id" {
  description = "ID of the VPC where the RDS instance will be created. If empty, will be discovered via remote state."
  type        = string
  default     = "" # Will use remote state from network module
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS subnet group. If empty, will be discovered via remote state."
  type        = list(string)
  default     = [] # Will use remote state from network module
} 