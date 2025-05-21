variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access to EC2 instance (e.g., your IP/32)"
  type        = string
  default     = "0.0.0.0/0" # Default is open, recommend restricting this
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3a.small" # 2 vCPUs, 4GB RAM
} 