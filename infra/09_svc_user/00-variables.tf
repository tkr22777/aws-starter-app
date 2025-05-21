variable "app_name" {
  type        = string
  description = "Name tag of the application"
  default     = "the-awesome-app"
}

variable "create_s3_user" {
  type        = bool
  description = "Whether to create a service user with S3 access"
  default     = true
}

variable "create_sqs_user" {
  type        = bool
  description = "Whether to create a service user with SQS access"
  default     = true
}

variable "create_dynamodb_user" {
  type        = bool
  description = "Whether to create a service user with DynamoDB access"
  default     = true
}

variable "create_rds_user" {
  type        = bool
  description = "Whether to create a service user with RDS access"
  default     = true
}

variable "create_combined_user" {
  type        = bool
  description = "Whether to create a service user with access to all services"
  default     = true
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket to grant access to"
  default     = "assets" # Will be prefixed with app_name
}

variable "sqs_queue_name" {
  type        = string
  description = "Name of the SQS queue to grant access to"
  default     = "main-queue" # Will be prefixed with app_name
}

variable "dynamodb_table_name" {
  type        = string
  description = "Name of the DynamoDB table to grant access to"
  default     = "mono-table" # Will be prefixed with app_name
}

variable "db_identifier" {
  type        = string
  description = "Identifier of the RDS database instance"
  default     = "database" # Will be prefixed with app_name
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block of the VPC where the RDS instance is located"
  default     = "10.0.0.0/16"
}

variable "s3_service_user_name" {
  description = "Name for the S3 service user"
  type        = string
  default     = "s3-svc-user"
}

variable "sqs_service_user_name" {
  description = "Name for the SQS service user"
  type        = string
  default     = "sqs-svc-user"
}

variable "dynamodb_service_user_name" {
  description = "Name for the DynamoDB service user"
  type        = string
  default     = "dynamodb-svc-user"
}

variable "rds_service_user_name" {
  description = "Name for the RDS service user"
  type        = string
  default     = "rds-svc-user"
} 