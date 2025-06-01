# =============================================================================
# SQS Management Policy
# =============================================================================

resource "aws_iam_policy" "sqs_management_policy" {
  name        = "terraform_user_sqs_management_policy"
  description = "Policy for AWS SQS queue management"
  
  tags = {
    Name = "terraform_user_sqs_management_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SQSManagement",
        Effect = "Allow",
        Action = [
          "sqs:CreateQueue", "sqs:DeleteQueue", "sqs:GetQueueAttributes", "sqs:SetQueueAttributes",
          "sqs:ListQueues", "sqs:GetQueueUrl", "sqs:SendMessage", "sqs:ReceiveMessage",
          "sqs:DeleteMessage", "sqs:ChangeMessageVisibility", "sqs:PurgeQueue",
          "sqs:TagQueue", "sqs:UntagQueue", "sqs:ListQueueTags",
          "sqs:AddPermission", "sqs:RemovePermission", "sqs:SetQueuePolicy",
          "sqs:GetQueuePolicy", "sqs:DeleteQueuePolicy"
        ],
        Resource = "*"
      }
    ]
  })
}

# =============================================================================
# Policy Attachment
# =============================================================================

resource "aws_iam_group_policy_attachment" "sqs_management_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.sqs_management_policy.arn
} 