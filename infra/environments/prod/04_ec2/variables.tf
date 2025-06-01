# =============================================================================
# Application Configuration
# =============================================================================

variable "app_name" {
  description = "Name of the application for tagging and resource naming."
  type        = string
  default     = "the-awesome-app-prod"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "prod"
}

# =============================================================================
# EC2 Instance Configuration
# =============================================================================

variable "instance_type" {
  description = "EC2 instance type for production workload."
  type        = string
  default     = "t3.small" # Slightly larger for production
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB."
  type        = number
  default     = 30 # Larger for production
}

variable "root_volume_type" {
  description = "Type of the root EBS volume."
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root EBS volume."
  type        = bool
  default     = true
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring for the instance."
  type        = bool
  default     = false # Disabled due to permission limitations
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance."
  type        = bool
  default     = true
}

# =============================================================================
# Security Configuration
# =============================================================================

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access to EC2 instance."
  type        = string
  default     = "0.0.0.0/0" # TESTING ONLY - For production, restrict to specific IP ranges (e.g., your office IP, VPN CIDR, or bastion host). Never use 0.0.0.0/0 in production!
}

variable "enable_ssh_access" {
  description = "Whether to enable SSH access to the instance."
  type        = bool
  default     = true
} 