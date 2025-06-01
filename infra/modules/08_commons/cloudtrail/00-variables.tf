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

variable "cloudtrail_name" {
  description = "Name for the CloudTrail"
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "S3 bucket name for CloudTrail logs. If not provided, will be auto-generated"
  type        = string
  default     = null
}

variable "include_global_service_events" {
  description = "Include global service events like IAM"
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "Enable multi-region trail"
  type        = bool
  default     = true
}

variable "enable_log_file_validation" {
  description = "Enable log file integrity validation"
  type        = bool
  default     = true
}

variable "event_selector" {
  description = "Event selector configuration for data events"
  type = object({
    read_write_type                 = optional(string, "All")
    include_management_events       = optional(bool, true)
    exclude_management_event_sources = optional(list(string), [])
    data_resource = optional(list(object({
      type   = string
      values = list(string)
    })), [])
  })
  default = {}
}

variable "kms_key_id" {
  description = "KMS key ID for CloudTrail log encryption. If not provided, will use default encryption"
  type        = string
  default     = null
}

variable "log_retention_days" {
  description = "Number of days to retain CloudTrail logs in S3"
  type        = number
  default     = 90
}

variable "archive_transition_days" {
  description = "Number of days before transitioning logs to IA storage"
  type        = number
  default     = 30
}

variable "glacier_transition_days" {
  description = "Number of days before transitioning logs to Glacier"
  type        = number
  default     = 60
}

variable "enable_cloudwatch_logs" {
  description = "Enable CloudWatch Logs delivery"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_retention" {
  description = "CloudWatch log group retention in days"
  type        = number
  default     = 14
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
} 