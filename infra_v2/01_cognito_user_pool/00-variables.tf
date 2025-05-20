variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

variable "app_callback_urls" {
  description = "List of allowed callback URLs for the Cognito app client."
  type        = list(string)
  default     = ["http://localhost:3000/callback"] # Example placeholder
}

variable "app_logout_urls" {
  description = "List of allowed logout URLs for the Cognito app client."
  type        = list(string)
  default     = ["http://localhost:3000/logout"] # Example placeholder
}