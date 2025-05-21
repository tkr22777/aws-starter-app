variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket (will be prefixed with app_name)"
  default     = "assets"
}

variable "enable_versioning" {
  type        = bool
  description = "Enable versioning on the bucket"
  default     = true
}

variable "enable_encryption" {
  type        = bool
  description = "Enable server-side encryption for the bucket"
  default     = true
}

variable "enable_logging" {
  type        = bool
  description = "Enable access logging for the bucket"
  default     = false
}

variable "lifecycle_rules" {
  type = list(object({
    id                                     = string
    enabled                                = bool
    prefix                                 = string
    expiration_days                        = number
    noncurrent_version_expiration_days     = number
    noncurrent_version_transition_days     = number
    noncurrent_version_transition_storage_class = string
  }))
  description = "Lifecycle rules for the bucket"
  default = [
    {
      id                                     = "default-rule"
      enabled                                = true
      prefix                                 = ""
      expiration_days                        = 0
      noncurrent_version_expiration_days     = 90
      noncurrent_version_transition_days     = 30
      noncurrent_version_transition_storage_class = "STANDARD_IA"
    }
  ]
}

variable "block_public_access" {
  type        = bool
  description = "Block all public access to the bucket"
  default     = true
} 