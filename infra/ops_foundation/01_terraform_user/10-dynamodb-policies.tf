# =============================================================================
# DynamoDB Management Policy
# =============================================================================

resource "aws_iam_policy" "dynamodb_management_policy" {
  name        = "terraform_user_dynamodb_management_policy"
  description = "Policy for DynamoDB table management"
  
  tags = {
    Name = "terraform_user_dynamodb_management_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DynamoDBManagement",
        Effect = "Allow",
        Action = [
          "dynamodb:CreateTable", "dynamodb:DeleteTable", "dynamodb:UpdateTable",
          "dynamodb:UpdateTimeToLive", "dynamodb:CreateBackup", "dynamodb:DeleteBackup",
          "dynamodb:RestoreTableFromBackup", "dynamodb:TagResource", "dynamodb:UntagResource",
          "dynamodb:UpdateContinuousBackups", "dynamodb:CreateGlobalTable",
          "dynamodb:UpdateGlobalTable", "dynamodb:DescribeGlobalTable",
          "dynamodb:CreateTableReplica", "dynamodb:UpdateTableReplica",
          "dynamodb:EnableKinesisStreamingDestination", "dynamodb:DisableKinesisStreamingDestination",
          "dynamodb:UpdateItem", "dynamodb:PutItem", "dynamodb:GetItem", "dynamodb:DeleteItem",
          "dynamodb:BatchWriteItem", "dynamodb:BatchGetItem", "dynamodb:Query", "dynamodb:Scan",
          "dynamodb:ConditionCheckItem"
        ],
        Resource = "*"
      }
    ]
  })
}

# =============================================================================
# Policy Attachment
# =============================================================================

resource "aws_iam_group_policy_attachment" "dynamodb_management_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.dynamodb_management_policy.arn
} 