# =============================================================================
# Application Configuration
# =============================================================================
variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "the-awesome-app"
}

variable "environment" {
  description = "Environment (e.g. dev, staging, prod)"
  type        = string
  default     = "development"
}

# =============================================================================
# EC2 Configuration
# =============================================================================
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "api_path_prefix" {
  description = "Path prefix for API routing (e.g., /api/*)"
  type        = string
  default     = "/api/*"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access to EC2 instance (e.g., your IP/32)"
  type        = string
  default     = "0.0.0.0/0" # Default is open, recommend restricting this
} 