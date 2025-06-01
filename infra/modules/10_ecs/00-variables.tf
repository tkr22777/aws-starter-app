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
# Network Configuration
# =============================================================================

variable "vpc_id" {
  description = "VPC ID to deploy ECS resources. If empty, will lookup by tags."
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID for ECS tasks. If empty, will lookup by tags."
  type        = string
  default     = ""
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to ECS tasks."
  type        = bool
  default     = true
}

variable "enable_execute_command" {
  description = "Enable ECS Exec for debugging container access."
  type        = bool
  default     = true
}

# =============================================================================
# ECS Configuration
# =============================================================================

variable "container_image" {
  description = "Docker image for the ECS service (registry/image:tag)."
  type        = string
  default     = ""  # Will use ECR repository + container_tag if empty
}

variable "container_tag" {
  description = "Docker image tag for the ECS service."
  type        = string
  default     = "latest"
}

variable "container_port" {
  description = "Port the container listens on."
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "Desired number of ECS tasks."
  type        = number
  default     = 1  # Single task for standalone
}

variable "cpu" {
  description = "CPU units for the task (256, 512, 1024, 2048, 4096)."
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory for the task in MB."
  type        = number
  default     = 512
}

# =============================================================================
# Auto Scaling Configuration
# =============================================================================

variable "enable_auto_scaling" {
  description = "Whether to enable auto scaling for the ECS service."
  type        = bool
  default     = false  # Disabled for standalone mode
}

variable "max_capacity" {
  description = "Maximum number of tasks when auto scaling is enabled."
  type        = number
  default     = 3
}

variable "cpu_target_value" {
  description = "Target CPU utilization percentage for auto scaling."
  type        = number
  default     = 70
}

variable "memory_target_value" {
  description = "Target memory utilization percentage for auto scaling."
  type        = number
  default     = 80
} 