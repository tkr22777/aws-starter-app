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
# VPC Configuration
# =============================================================================

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# =============================================================================
# Main Subnet Configuration
# =============================================================================

variable "subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone for the subnet"
  default     = "us-east-1a"
}

# =============================================================================
# HA Subnet Configuration
# =============================================================================

variable "subnet_ha_2_cidr_block" {
  description = "CIDR block for the second HA subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "subnet_ha_2_availability_zone" {
  description = "Availability zone for the second HA subnet"
  type        = string
  default     = "us-east-1b"
} 