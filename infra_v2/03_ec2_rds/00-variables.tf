variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

variable "db_password" {
  description = "Password for the RDS database instance"
  type        = string
  sensitive   = true
  # No default - user must provide this for security
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access to EC2 instance (e.g., your IP/32)"
  type        = string
  default     = "0.0.0.0/0" # Default is open, recommend restricting this
}