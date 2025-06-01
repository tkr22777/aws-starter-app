variable "state_bucket_name" {
  description = "The name for the S3 bucket that will store Terraform state."
  type        = string
  default     = "terraform-state-store-24680" # Ensure this is globally unique if not customized
}

variable "dynamodb_lock_table_name" {
  description = "The name for the DynamoDB table used for Terraform state locking."
  type        = string
  default     = "terraform-state-locks"
} 