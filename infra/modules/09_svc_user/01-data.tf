data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Look up the VPC by name tag - optional
data "aws_vpc" "app_vpc" {
  count = 0 # Disable for now  
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-vpc"]
  }
}

# Use placeholders for resources that may not exist yet
locals {
  # Resource ARNs for policies
  s3_bucket_arn     = "arn:aws:s3:::${var.app_name}-${var.s3_bucket_name}"
  s3_bucket_path_arn = "arn:aws:s3:::${var.app_name}-${var.s3_bucket_name}/*"
  sqs_queue_arn     = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.app_name}-${var.sqs_queue_name}"
  dynamodb_table_arn = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.app_name}-${var.dynamodb_table_name}"
  rds_db_arn        = "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:db:${var.app_name}-${var.db_identifier}"
  rds_dbuser_arn    = "arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:*/*"
} 