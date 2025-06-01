variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table"
  default     = "mono-table"
}

variable "billing_mode" {
  type        = string
  description = "DynamoDB billing mode (PROVISIONED or PAY_PER_REQUEST)"
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  type        = number
  description = "Read capacity units for the table (only applicable for PROVISIONED billing mode)"
  default     = 5
}

variable "write_capacity" {
  type        = number
  description = "Write capacity units for the table (only applicable for PROVISIONED billing mode)"
  default     = 5
}

variable "hash_key" {
  type        = string
  description = "Attribute name for the hash key (partition key)"
  default     = "PK"
}

variable "range_key" {
  type        = string
  description = "Attribute name for the range key (sort key)"
  default     = "SK"
}

variable "ttl_attribute" {
  type        = string
  description = "Attribute name for TTL (Time To Live)"
  default     = "TTL"
}

variable "enable_point_in_time_recovery" {
  type        = bool
  description = "Enable point-in-time recovery for the DynamoDB table"
  default     = true
}

variable "enable_encryption" {
  type        = bool
  description = "Enable server-side encryption for the DynamoDB table"
  default     = true
} 