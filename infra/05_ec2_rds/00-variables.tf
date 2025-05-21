variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

# Optional variables for resource override (typically not needed)
variable "ec2_security_group_id" {
  description = "Override for EC2 security group ID"
  type        = string
  default     = "" # Empty means use data source
}

variable "rds_security_group_id" {
  description = "Override for RDS security group ID"
  type        = string
  default     = "" # Empty means use data source
} 