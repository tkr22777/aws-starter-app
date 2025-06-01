# =============================================================================
# Application Configuration
# =============================================================================

variable "app_name" {
  description = "Name of the application for tagging and resource naming."
  type        = string
  default     = "the-awesome-app-prod"
}

variable "environment" {
  description = "Deployment environment (e.g., prod, dev, staging)."
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "The AWS region where resources will be deployed."
  type        = string
  default     = "us-east-1"
}

# =============================================================================
# VPC Configuration
# =============================================================================

variable "vpc_cidr_block" {
  description = "CIDR block for the production VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# =============================================================================
# Main Subnet Configuration
# =============================================================================

variable "subnet_cidr_block" {
  description = "CIDR block for the primary production subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone for the primary production subnet"
  default     = "us-east-1a"
}

# =============================================================================
# HA Subnet Configuration
# =============================================================================

variable "subnet_ha_2_cidr_block" {
  description = "CIDR block for the second HA production subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "subnet_ha_2_availability_zone" {
  description = "Availability zone for the second HA production subnet"
  type        = string
  default     = "us-east-1b"
} 