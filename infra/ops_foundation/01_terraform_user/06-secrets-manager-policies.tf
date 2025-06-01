# =============================================================================
# Secrets Manager Policy
# =============================================================================

resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "terraform_user_secrets_manager_policy"
  description = "Policy for AWS Secrets Manager management"
  
  tags = {
    Name = "terraform_user_secrets_manager_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
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

resource "aws_iam_group_policy_attachment" "secrets_manager_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
} 