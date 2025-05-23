variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

variable "api_path_prefix" {
  type        = string
  description = "Path prefix for ECS service routing (e.g., /app, /api/v1)"
  default     = "/*"
}

variable "container_image" {
  type        = string
  description = "Docker image for the ECS service"
  default     = "nginx:latest"
}

variable "container_port" {
  type        = number
  description = "Port the container listens on"
  default     = 80
}

variable "desired_count" {
  type        = number
  description = "Desired number of ECS tasks"
  default     = 2
}

variable "cpu" {
  type        = number
  description = "CPU units for the task (256, 512, 1024, etc.)"
  default     = 256
}

variable "memory" {
  type        = number
  description = "Memory for the task in MB"
  default     = 512
}

variable "health_check_path" {
  type        = string
  description = "Health check path for ALB target group"
  default     = "/"
} 