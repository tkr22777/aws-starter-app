# =============================================================================
# Application Configuration
# =============================================================================
variable "app_name" {
  description = "Name of the application for tagging and resource naming."
  type        = string
  default     = "the-awesome-app"
}

variable "environment" {
  description = "Environment name (e.g., prod, dev, staging)."
  type        = string
  default     = "prod"
}

# =============================================================================
# EC2 Instance Configuration
# =============================================================================
variable "instance_type" {
  description = "EC2 instance type (e.g., t3.micro, t3.small, m5.large)."
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB."
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type of the root EBS volume (gp3, gp2, io1, io2)."
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
  default     = false
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance."
  type        = bool
  default     = true
}

# =============================================================================
# Application Configuration
# =============================================================================
variable "api_path_prefix" {
  description = "Path prefix for API routing (e.g., /api/*)."
  type        = string
  default     = "/api/*"
}

# =============================================================================
# Security Configuration
# =============================================================================
variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access to EC2 instance (e.g., your IP/32)."
  type        = string
  default     = "10.0.0.0/8" # Default to private networks only
}

variable "enable_ssh_access" {
  description = "Whether to enable SSH access to the instance."
  type        = bool
  default     = true
}

# =============================================================================
# Network Configuration (Optional - uses data sources if not provided)
# =============================================================================
variable "vpc_id" {
  description = "ID of the VPC where the EC2 instance will be created. If not provided, will be discovered via data source."
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance will be placed. If not provided, will be discovered via data source."
  type        = string
  default     = ""
} 