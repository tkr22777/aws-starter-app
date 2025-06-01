# =============================================================================
# Application Configuration
# =============================================================================

variable "app_name" {
  type        = string
  description = "Base name of the application, used for resource naming and tagging."
  default     = "the-awesome-app"
}

variable "environment" {
  description = "Environment name (e.g., prod, dev, staging)."
  type        = string
  default     = "prod"
}

# =============================================================================
# Database Configuration
# =============================================================================

variable "db_password" {
  description = "Password for the RDS database instance"
  type        = string
  sensitive   = true
  default     = "abcd1234" # TODO: Use AWS Secrets Manager in production
}

# =============================================================================
# Network Configuration (Optional - uses data sources if not provided)
# =============================================================================

variable "vpc_id" {
  description = "ID of the VPC where the RDS instance will be created. If not provided, will be discovered via data source."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS subnet group. If not provided, will be discovered via data source."
  type        = list(string)
  default     = []
} 