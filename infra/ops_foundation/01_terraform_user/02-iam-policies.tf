# =============================================================================
# IAM Management Policy
# =============================================================================

resource "aws_iam_policy" "iam_management_policy" {
  name        = "terraform_user_iam_management_policy"
  description = "Policy for IAM roles, policies, and users management"
  
  tags = {
    Name = "terraform_user_iam_management_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "IAMRoleManagement",
        Effect = "Allow",
        Action = [
          "iam:PassRole", 
          "iam:CreateRole", "iam:UpdateRole", "iam:DeleteRole", "iam:TagRole",
          "iam:CreateServiceLinkedRole",
          "iam:ListInstanceProfilesForRole",
          "iam:CreatePolicy", "iam:DeletePolicy", "iam:TagPolicy", "iam:GetPolicy", "iam:GetPolicyVersion",
          "iam:ListPolicyVersions", "iam:CreatePolicyVersion", "iam:DeletePolicyVersion", "iam:SetDefaultPolicyVersion",
          "iam:AttachRolePolicy", "iam:DetachRolePolicy", 
          "iam:PutRolePolicy", "iam:DeleteRolePolicy",
          "iam:CreateUser", "iam:DeleteUser", "iam:GetUser", "iam:ListUsers", "iam:TagUser", "iam:UntagUser", "iam:UpdateUser",
          "iam:ListGroupsForUser", "iam:AddUserToGroup", "iam:RemoveUserFromGroup", 
          "iam:CreateAccessKey", "iam:DeleteAccessKey", "iam:UpdateAccessKey", "iam:ListAccessKeys", "iam:GetAccessKeyLastUsed",
          "iam:AttachUserPolicy", "iam:DetachUserPolicy", "iam:ListAttachedUserPolicies", 
          "iam:PutUserPolicy", "iam:DeleteUserPolicy", "iam:GetUserPolicy", "iam:ListUserPolicies"
        ],
        Resource = "*"
      }
    ]
  })
}

# =============================================================================
# Policy Attachment
# =============================================================================

resource "aws_iam_group_policy_attachment" "iam_management_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.iam_management_policy.arn
} 