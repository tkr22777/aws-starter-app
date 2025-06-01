variable "app_name" {
  description = "Application name for resource naming"
  type        = string
  default     = "the-awesome-app"
}

variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
  default     = "development"
}

variable "kms_keys" {
  description = "Map of KMS keys to create"
  type = map(object({
    description             = string
    key_usage              = optional(string, "ENCRYPT_DECRYPT")
    key_spec               = optional(string, "SYMMETRIC_DEFAULT")
    deletion_window_in_days = optional(number, 30)
    enable_key_rotation     = optional(bool, true)
    multi_region           = optional(bool, false)
    policy                 = optional(string, null)
    aliases                = optional(list(string), [])
    tags                   = optional(map(string), {})
  }))
  default = {
    general = {
      description = "General purpose encryption key for application data"
      aliases     = ["general", "app-data"]
    }
    s3 = {
      description = "Encryption key for S3 buckets"
      aliases     = ["s3", "bucket-encryption"]
    }
    database = {
      description = "Encryption key for database storage"
      aliases     = ["database", "rds", "dynamodb"]
    }
    secrets = {
      description = "Encryption key for secrets and sensitive data"
      aliases     = ["secrets", "secrets-manager"]
    }
  }
}

variable "grant_principals" {
  description = "List of IAM principals to grant full access to all keys"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
} 