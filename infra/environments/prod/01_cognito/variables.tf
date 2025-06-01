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

variable "app_callback_urls" {
  description = "List of allowed callback URLs for the Cognito app client in production."
  type        = list(string)
  default     = ["https://prod.example.com/callback"] # Replace with actual production callback URLs
}

variable "app_logout_urls" {
  description = "List of allowed logout URLs for the Cognito app client in production."
  type        = list(string)
  default     = ["https://prod.example.com/logout"] # Replace with actual production logout URLs
} 