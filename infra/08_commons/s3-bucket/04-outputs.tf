output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "The versioning status of the bucket"
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}

output "bucket_region" {
  description = "The AWS region the bucket resides in"
  value       = data.aws_region.current.name
} 