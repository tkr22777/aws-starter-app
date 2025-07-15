# =============================================================================
# Security and Encryption Management Policy (KMS + Secrets Manager + Cognito)
# =============================================================================

resource "aws_iam_policy" "security_management_policy" {
  name        = "terraform_user_security_management_policy"
  description = "Policy for KMS key management, AWS Secrets Manager operations, and Cognito authentication services"
  
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
      },
      {
        Sid    = "CognitoUserPoolManagement",
        Effect = "Allow",
        Action = [
          "cognito-idp:CreateUserPool", "cognito-idp:UpdateUserPool", "cognito-idp:DeleteUserPool",
          "cognito-idp:DescribeUserPool", "cognito-idp:ListUserPools",
          "cognito-idp:CreateUserPoolClient", "cognito-idp:UpdateUserPoolClient", "cognito-idp:DeleteUserPoolClient",
          "cognito-idp:DescribeUserPoolClient", "cognito-idp:ListUserPoolClients",
          "cognito-idp:CreateUserPoolDomain", "cognito-idp:UpdateUserPoolDomain", "cognito-idp:DeleteUserPoolDomain",
          "cognito-idp:DescribeUserPoolDomain",
          "cognito-idp:SetUICustomization", "cognito-idp:GetUICustomization",
          "cognito-idp:GetUserPoolMfaConfig", "cognito-idp:SetUserPoolMfaConfig",
          "cognito-idp:TagResource", "cognito-idp:UntagResource", "cognito-idp:ListTagsForResource"
        ],
        Resource = "*"
      },
      {
        Sid    = "CognitoIdentityPoolManagement",
        Effect = "Allow",
        Action = [
          "cognito-identity:CreateIdentityPool", "cognito-identity:UpdateIdentityPool", "cognito-identity:DeleteIdentityPool",
          "cognito-identity:DescribeIdentityPool", "cognito-identity:ListIdentityPools",
          "cognito-identity:SetIdentityPoolRoles", "cognito-identity:GetIdentityPoolRoles",
          "cognito-identity:TagResource", "cognito-identity:UntagResource", "cognito-identity:ListTagsForResource"
        ],
        Resource = "*"
      },
      {
        Sid    = "CognitoUserManagement",
        Effect = "Allow",
        Action = [
          "cognito-idp:CreateUser", "cognito-idp:AdminCreateUser", "cognito-idp:AdminDeleteUser",
          "cognito-idp:AdminGetUser", "cognito-idp:ListUsers",
          "cognito-idp:AdminSetUserPassword", "cognito-idp:AdminResetUserPassword",
          "cognito-idp:AdminConfirmSignUp", "cognito-idp:AdminDisableUser", "cognito-idp:AdminEnableUser",
          "cognito-idp:AdminAddUserToGroup", "cognito-idp:AdminRemoveUserFromGroup",
          "cognito-idp:CreateGroup", "cognito-idp:UpdateGroup", "cognito-idp:DeleteGroup",
          "cognito-idp:GetGroup", "cognito-idp:ListGroups", "cognito-idp:ListUsersInGroup"
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