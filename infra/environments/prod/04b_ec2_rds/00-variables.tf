# =============================================================================
# Application Configuration
# =============================================================================

variable "app_name" {
  description = "Name of the application for tagging and resource naming."
  type        = string
  default     = "the-awesome-app"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "prod"
}

# =============================================================================
# Security Group Overrides (Optional)
# =============================================================================

variable "ec2_security_group_id" {
  description = "Override for EC2 security group ID. If empty, will be discovered via data source."
  type        = string
  default     = ""
}

variable "rds_security_group_id" {
  description = "Override for RDS security group ID. If empty, will be discovered via data source."
  type        = string
  default     = ""
} 