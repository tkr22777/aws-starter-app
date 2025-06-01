variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "aws-starter-app"
}

variable "terraform_user_name" {
  description = "The name of the IAM user for Terraform"
  type        = string
  default     = "terraform_user"
}

variable "terraform_user_group_membership_name" {
  description = "The name of the IAM group membership for Terraform user"
  type        = string
  default     = "terraform_user_group_membership"
}

variable "terraform_user_group_name" {
  description = "The name of the IAM group for Terraform user"
  type        = string
  default     = "terraform_user_group"
}

variable "terraform_user_group_policy_name" {
  description = "The name of the IAM policy for Terraform user group"
  type        = string
  default     = "terraform_user_group_policy"
}

variable "state_bucket_name_for_policy" {
  description = "The name of the S3 bucket used for storing Terraform state"
  type        = string
  default     = "terraform-state-store-24680"
}

variable "dynamodb_lock_table_name_for_policy" {
  description = "The name of the DynamoDB table used for Terraform state locking"
  type        = string
  default     = "terraform-state-locks"
} 