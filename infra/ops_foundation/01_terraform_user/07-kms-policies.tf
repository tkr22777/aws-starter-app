# =============================================================================
# KMS Management Policy
# =============================================================================

resource "aws_iam_policy" "kms_policy" {
  name        = "terraform_user_kms_policy"
  description = "Policy for AWS KMS key management"
  
  tags = {
    Name = "terraform_user_kms_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "KMSManagement",
        Effect = "Allow",
        Action = [
          "kms:CreateKey", "kms:DescribeKey", "kms:GetKeyPolicy", "kms:GetKeyRotationStatus",
          "kms:ListKeys", "kms:ListAliases", "kms:ListResourceTags", "kms:TagResource", "kms:UntagResource",
          "kms:EnableKey", "kms:DisableKey", "kms:EnableKeyRotation", "kms:DisableKeyRotation",
          "kms:PutKeyPolicy", "kms:ScheduleKeyDeletion", "kms:CancelKeyDeletion",
          "kms:CreateAlias", "kms:DeleteAlias", "kms:UpdateAlias",
          "kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*", "kms:GenerateDataKey*",
          "kms:CreateGrant", "kms:ListGrants", "kms:RevokeGrant"
        ],
        Resource = "*"
      }
    ]
  })
}

# =============================================================================
# Policy Attachment
# =============================================================================

resource "aws_iam_group_policy_attachment" "kms_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.kms_policy.arn
} 