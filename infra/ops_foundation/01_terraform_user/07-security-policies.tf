# =============================================================================
# Security and Encryption Management Policy (KMS + Secrets Manager)
# =============================================================================

resource "aws_iam_policy" "security_management_policy" {
  name        = "terraform_user_security_management_policy"
  description = "Policy for KMS key management and AWS Secrets Manager operations"
  
  tags = {
    Name = "terraform_user_security_management_policy"
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
      },
      {
        Sid    = "SecretsManagerManagement",
        Effect = "Allow",
        Action = [
          "secretsmanager:CreateSecret", "secretsmanager:DeleteSecret", "secretsmanager:UpdateSecret",
          "secretsmanager:DescribeSecret", "secretsmanager:GetSecretValue", "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage", "secretsmanager:ListSecrets", "secretsmanager:ListSecretVersionIds",
          "secretsmanager:TagResource", "secretsmanager:UntagResource", "secretsmanager:GetResourcePolicy",
          "secretsmanager:PutResourcePolicy", "secretsmanager:DeleteResourcePolicy",
          "secretsmanager:RestoreSecret", "secretsmanager:RotateSecret", "secretsmanager:CancelRotateSecret",
          "secretsmanager:ReplicateSecretToRegions", "secretsmanager:RemoveRegionsFromReplication"
        ],
        Resource = "*"
      }
    ]
  })
}

# =============================================================================
# Policy Attachment
# =============================================================================

resource "aws_iam_group_policy_attachment" "security_management_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.security_management_policy.arn
} 