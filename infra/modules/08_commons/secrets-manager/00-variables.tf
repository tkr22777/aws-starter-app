variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "development"
}

variable "secrets" {
  type = map(object({
    description          = string
    secret_string        = optional(string)
    generate_password    = optional(bool, false)
    password_length      = optional(number, 32)
    exclude_characters   = optional(string, " \"'\\/@")
    include_special      = optional(bool, true)
    recovery_window_days = optional(number, 30)
    tags                 = optional(map(string), {})
  }))
  description = "Map of secrets to create in AWS Secrets Manager"
  default = {
    "database-password" = {
      description          = "Database master password"
      generate_password    = true
      password_length      = 16
      exclude_characters   = " \"'\\/@"
      recovery_window_days = 7
    }
    "api-key" = {
      description          = "API key for external service"
      secret_string        = "changeme-api-key"
      recovery_window_days = 30
    }
  }
}

variable "kms_key_id" {
  type        = string
  description = "KMS key ID for encrypting secrets. If not provided, uses AWS managed key"
  default     = null
}

variable "replica_regions" {
  type = list(object({
    region     = string
    kms_key_id = optional(string)
  }))
  description = "List of regions to replicate secrets to"
  default     = []
}

variable "enable_rotation" {
  type        = bool
  description = "Whether to enable automatic rotation for secrets"
  default     = false
}

variable "rotation_lambda_arn" {
  type        = string
  description = "ARN of the Lambda function for automatic rotation"
  default     = null
} 