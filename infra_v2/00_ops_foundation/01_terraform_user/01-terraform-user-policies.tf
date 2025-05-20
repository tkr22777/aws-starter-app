resource "aws_iam_user" "terraform_user" {
  name = "terraform_user"
}

resource "aws_iam_group_membership" "example_membership" {
  name = "example_user_membership"

  users = [
    aws_iam_user.terraform_user.name,
  ]

  group = aws_iam_group.terraform_user_group.name
}

resource "aws_iam_group" "terraform_user_group" {
  name = "terraform_user_group"
}

resource "aws_iam_policy" "terraform_user_policy" {
  name        = "terraform_user_policy"
  description = "Policy for terraform infrastructure management"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "rds:*",
          "ecr:*",
          "ecs:*",
          "cognito-idp:*",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "terraform_user_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.terraform_user_policy.arn
}

output "terraform_user_name" {
  description = "The name of the created IAM user"
  value       = aws_iam_user.terraform_user.name
}

output "terraform_user_arn" {
  description = "The ARN of the created IAM user"
  value       = aws_iam_user.terraform_user.arn
}

output "terraform_user_unique_id" {
  description = "The unique ID assigned by AWS for the IAM user"
  value       = aws_iam_user.terraform_user.unique_id
}

output "terraform_user_group_name" {
  description = "The name of the IAM group created for the Terraform user"
  value       = aws_iam_group.terraform_user_group.name
}

output "terraform_user_group_arn" {
  description = "The ARN of the IAM group created for the Terraform user"
  value       = aws_iam_group.terraform_user_group.arn
}