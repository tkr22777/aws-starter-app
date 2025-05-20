variable "app_name" {
  description = "Application name, used for tagging resources."
  type        = string
  default     = "ops-foundation"
}

variable "terraform_user_name" {
  description = "The name for the IAM user for Terraform operations."
  type        = string
  default     = "terraform_user"
}

variable "terraform_user_group_name" {
  description = "The name for the IAM group for the Terraform user."
  type        = string
  default     = "terraform_user_group"
}

variable "terraform_user_group_policy_name" {
  description = "The name for the IAM policy attached to the Terraform user group."
  type        = string
  default     = "terraform_user_group_policy"
}

variable "terraform_user_group_membership_name" {
  description = "The name for the IAM group membership resource."
  type        = string
  default     = "terraform_user_group_membership"
}

variable "state_bucket_name_for_policy" {
  description = "The name of the S3 bucket used for Terraform state (for IAM policy)."
  type        = string
  default     = "terraform-state-store-24680"
}

variable "dynamodb_lock_table_name_for_policy" {
  description = "The name of the DynamoDB table for state locking (for IAM policy)."
  type        = string
  default     = "terraform-state-locks"
} 