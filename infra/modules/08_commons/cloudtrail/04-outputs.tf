output "cloudtrail_id" {
  description = "The ID of the CloudTrail"
  value       = aws_cloudtrail.main.id
}

output "cloudtrail_arn" {
  description = "The ARN of the CloudTrail"
  value       = aws_cloudtrail.main.arn
}

output "cloudtrail_name" {
  description = "The name of the CloudTrail"
  value       = aws_cloudtrail.main.name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail_logs.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail_logs.arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.cloudtrail[0].name : null
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.cloudtrail[0].arn : null
}

output "iam_role_arn" {
  description = "ARN of the IAM role for CloudWatch logs"
  value       = var.enable_cloudwatch_logs ? aws_iam_role.cloudtrail_cloudwatch_role[0].arn : null
}

# Useful CLI commands
output "aws_cli_commands" {
  description = "Useful AWS CLI commands for CloudTrail"
  value = {
    describe_trail = "aws cloudtrail describe-trails --trail-name-list ${aws_cloudtrail.main.name}"
    get_trail_status = "aws cloudtrail get-trail-status --name ${aws_cloudtrail.main.name}"
    lookup_events = "aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=CreateUser --start-time 2024-01-01 --end-time 2024-12-31"
    list_s3_objects = "aws s3 ls s3://${aws_s3_bucket.cloudtrail_logs.bucket}/ --recursive"
    view_recent_logs = var.enable_cloudwatch_logs ? "aws logs filter-log-events --log-group-name ${aws_cloudwatch_log_group.cloudtrail[0].name} --start-time $(date -d '1 hour ago' +%s)000" : "CloudWatch logs not enabled"
  }
}

# Account and region info
output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "region" {
  description = "AWS Region"
  value       = data.aws_region.current.name
} 