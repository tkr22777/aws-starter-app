# =============================================================================
# RDS Management Policy
# =============================================================================

resource "aws_iam_policy" "rds_management_policy" {
  name        = "terraform_user_rds_management_policy"
  description = "Policy for RDS database management"
  
  tags = {
    Name = "terraform_user_rds_management_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "RDSManagement",
        Effect = "Allow",
        Action = [
          "rds:CreateDBInstance", "rds:DeleteDBInstance", "rds:ModifyDBInstance", "rds:RebootDBInstance", "rds:StartDBInstance", "rds:StopDBInstance",
          "rds:CreateDBSnapshot", "rds:DeleteDBSnapshot", "rds:CopyDBSnapshot", "rds:CreateDBSubnetGroup", "rds:DeleteDBSubnetGroup", "rds:ModifyDBSubnetGroup",
          "rds:CreateDBParameterGroup", "rds:DeleteDBParameterGroup", "rds:ModifyDBParameterGroup", "rds:CreateDBCluster", "rds:DeleteDBCluster", "rds:ModifyDBCluster",
          "rds:CreateDBClusterSnapshot", "rds:DeleteDBClusterSnapshot", "rds:AddTagsToResource", "rds:RemoveTagsFromResource", "rds:ListTagsForResource"
        ],
        Resource = "*"
      }
    ]
  })
}

# =============================================================================
# Policy Attachment
# =============================================================================

resource "aws_iam_group_policy_attachment" "rds_management_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.rds_management_policy.arn
} 