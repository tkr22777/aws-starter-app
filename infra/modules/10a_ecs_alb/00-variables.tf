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
# ECS Service Reference
# =============================================================================

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster to integrate with ALB."
  type        = string
  default     = ""  # Will lookup by tags if empty
}

variable "ecs_service_name" {
  description = "Name of the ECS service to integrate with ALB."
  type        = string
  default     = ""  # Will lookup by tags if empty
}

variable "container_name" {
  description = "Name of the container to route traffic to."
  type        = string
  default     = ""  # Will use app_name if empty
}

variable "container_port" {
  description = "Port the container listens on."
  type        = number
  default     = 80
}

# =============================================================================
# ALB Integration Configuration
# =============================================================================

variable "alb_arn" {
  description = "ARN of the Application Load Balancer."
  type        = string
  default     = ""  # Will lookup by tags if empty
}

variable "alb_listener_arn" {
  description = "ARN of the ALB listener to attach rules to."
  type        = string
  default     = ""  # Will lookup by tags if empty
}

variable "listener_priority" {
  description = "Priority for the ALB listener rule (1-50000)."
  type        = number
  default     = 100
}

variable "path_pattern" {
  description = "Path pattern for routing requests to ECS service."
  type        = string
  default     = "/api/*"
}

variable "host_header" {
  description = "Host header for routing (optional)."
  type        = string
  default     = ""
}

# =============================================================================
# Target Group Configuration
# =============================================================================

variable "health_check_enabled" {
  description = "Enable health checks for the target group."
  type        = bool
  default     = true
}

variable "health_check_path" {
  description = "Health check path for the target group."
  type        = string
  default     = "/health"
}

variable "health_check_interval" {
  description = "Health check interval in seconds."
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds."
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of consecutive health checks before marking healthy."
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Number of consecutive health check failures before marking unhealthy."
  type        = number
  default     = 3
}

variable "health_check_matcher" {
  description = "HTTP response codes for successful health checks."
  type        = string
  default     = "200"
}

# =============================================================================
# Network Configuration
# =============================================================================

variable "vpc_id" {
  description = "VPC ID for the target group. If empty, will lookup by tags."
  type        = string
  default     = ""
}

variable "target_group_protocol" {
  description = "Protocol for the target group (HTTP, HTTPS)."
  type        = string
  default     = "HTTP"
}

variable "deregistration_delay" {
  description = "Time to wait for requests to complete before deregistering targets."
  type        = number
  default     = 30
} 