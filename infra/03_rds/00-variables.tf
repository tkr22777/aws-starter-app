variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

variable "db_password" {
  description = "Password for the RDS database instance"
  type        = string
  # sensitive   = true # TO DO: remove this
  default     = "abcd1234"
}

variable "vpc_id" {
  description = "ID of the VPC where the RDS instance will be created"
  type        = string
  default     = ""  # Will be populated by data source if not provided
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS subnet group"
  type        = list(string)
  default     = []  # Will be populated by data source if not provided
} 