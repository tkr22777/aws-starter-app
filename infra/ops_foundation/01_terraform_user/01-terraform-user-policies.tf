resource "aws_iam_user" "terraform_user" {
  name = var.terraform_user_name
  
  tags = {
    Name = var.terraform_user_name
  }
}

resource "aws_iam_group_membership" "example_membership" {
  name = var.terraform_user_group_membership_name

  users = [
    aws_iam_user.terraform_user.name,
  ]

  group = aws_iam_group.terraform_user_group.name
}

resource "aws_iam_group" "terraform_user_group" {
  name = var.terraform_user_group_name
}

# Core policy with simple permissions that don't warrant separate policies
resource "aws_iam_policy" "terraform_user_group_policy" {
  name        = var.terraform_user_group_policy_name
  description = "Core policy for terraform infrastructure management - read access and state management"
  
  tags = {
    Name = var.terraform_user_group_policy_name
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadOnlyAccess",
        Effect = "Allow",
        Action = [
          "ec2:Describe*", "rds:Describe*", "ecr:Describe*", "ecr:Get*", "ecr:List*",
          "ecs:Describe*", "ecs:List*", "cognito-idp:Describe*", "cognito-idp:List*", "cognito-idp:Get*",
          "s3:GetBucketLocation", "s3:ListAllMyBuckets",
          "iam:ListAccountAliases", "iam:GetAccountSummary",
          "iam:GetUser", "iam:ListUsers", "iam:GetRole", "iam:ListRoles", "iam:GetPolicy", "iam:ListPolicies", "iam:ListAttachedRolePolicies", "iam:GetRolePolicy", "iam:ListRolePolicies",
          "iam:GetGroup", "iam:ListGroups", "iam:ListAttachedGroupPolicies", "iam:GetGroupPolicy", "iam:ListGroupPolicies",
          "sts:GetCallerIdentity", "cloudwatch:DescribeAlarms", "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics", "cloudwatch:ListMetrics",
          "dynamodb:DescribeTable", "dynamodb:List*", "dynamodb:DescribeTimeToLive", "dynamodb:DescribeContinuousBackups",
          "cloudtrail:ListTrails", "cloudtrail:DescribeTrails",
          "lambda:ListFunctions", "lambda:GetFunction",
          "tag:GetResources", "tag:GetTagKeys", "tag:GetTagValues"
        ],
        Resource = "*"
      },
      {
        Sid    = "S3StateBucketAccess",
        Effect = "Allow",
        Action = [ "s3:GetObject", "s3:PutObject", "s3:DeleteObject" ],
        Resource = "arn:aws:s3:::${var.state_bucket_name_for_policy}/*"
      },
      {
        Sid    = "S3StateBucketListAccess",
        Effect = "Allow",
        Action = [ "s3:ListBucket", "s3:GetBucketVersioning" ],
        Resource = "arn:aws:s3:::${var.state_bucket_name_for_policy}"
      },
      {
        Sid    = "DynamoDBLockTableAccess",
        Effect = "Allow",
        Action = [ "dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem", "dynamodb:DescribeTable" ],
        Resource = "arn:aws:dynamodb:us-east-1:*:table/${var.dynamodb_lock_table_name_for_policy}"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "terraform_user_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.terraform_user_group_policy.arn
}

# Outputs for the Terraform user and related resources
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