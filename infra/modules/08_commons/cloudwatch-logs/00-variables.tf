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

variable "log_groups" {
  description = "Map of log groups to create"
  type = map(object({
    retention_in_days = optional(number, 30)
    kms_key_id       = optional(string, null)
    tags             = optional(map(string), {})
  }))
  default = {
    app = {
      retention_in_days = 30
    }
    api = {
      retention_in_days = 30
    }
    web = {
      retention_in_days = 14
    }
    worker = {
      retention_in_days = 30
    }
    database = {
      retention_in_days = 7
    }
    security = {
      retention_in_days = 90
    }
    performance = {
      retention_in_days = 7
    }
    audit = {
      retention_in_days = 365
    }
  }
}

variable "metric_filters" {
  description = "Map of metric filters to create for alerting"
  type = map(object({
    log_group_name   = string
    filter_pattern   = string
    metric_namespace = optional(string, "Application/Logs")
    metric_name      = string
    metric_value     = optional(string, "1")
    default_value    = optional(number, 0)
  }))
  default = {
    error_count = {
      log_group_name = "app"
      filter_pattern = "[timestamp, request_id, level=\"ERROR\", ...]"
      metric_name    = "ErrorCount"
    }
    warning_count = {
      log_group_name = "app"
      filter_pattern = "[timestamp, request_id, level=\"WARN\", ...]"
      metric_name    = "WarningCount"
    }
    api_errors = {
      log_group_name = "api"
      filter_pattern = "[timestamp, request_id, level=\"ERROR\", ...]"
      metric_name    = "APIErrorCount"
    }
    slow_queries = {
      log_group_name = "database"
      filter_pattern = "[timestamp, level, message=\"slow query\", duration>1000, ...]"
      metric_name    = "SlowQueryCount"
    }
  }
}

variable "subscription_filters" {
  description = "Map of subscription filters for real-time log processing"
  type = map(object({
    log_group_name  = string
    filter_pattern  = string
    destination_arn = string
    role_arn       = optional(string, null)
  }))
  default = {}
}

variable "enable_insights" {
  description = "Enable CloudWatch Logs Insights for advanced querying"
  type        = bool
  default     = true
}

variable "export_bucket" {
  description = "S3 bucket name for log exports (for long-term storage)"
  type        = string
  default     = null
}

variable "default_retention_days" {
  description = "Default retention period for log groups"
  type        = number
  default     = 30
}

variable "cost_optimization" {
  description = "Enable cost optimization features"
  type = object({
    enable_log_class_standard_ia = optional(bool, false)
    enable_auto_export          = optional(bool, false)
    export_frequency_days       = optional(number, 30)
  })
  default = {
    enable_log_class_standard_ia = false
    enable_auto_export          = false
    export_frequency_days       = 30
  }
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
} 