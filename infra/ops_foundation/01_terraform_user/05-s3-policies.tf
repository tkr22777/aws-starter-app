# =============================================================================
# S3 Bucket Management Policy
# =============================================================================

resource "aws_iam_policy" "s3_bucket_management_policy" {
  name        = "terraform_user_s3_bucket_management_policy"
  description = "Policy for S3 bucket management"
  
  tags = {
    Name = "terraform_user_s3_bucket_management_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3BucketFullAccess",
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = "*"
      }
    ]
  })
}

# =============================================================================
# Policy Attachment
# =============================================================================

resource "aws_iam_group_policy_attachment" "s3_bucket_management_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.s3_bucket_management_policy.arn
} 