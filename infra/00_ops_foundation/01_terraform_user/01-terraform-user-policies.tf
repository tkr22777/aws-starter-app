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

resource "aws_iam_policy" "terraform_user_group_policy" {
  name        = var.terraform_user_group_policy_name
  description = "Policy for terraform infrastructure management with least privilege in mind"
  
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
          "sts:GetCallerIdentity", "cloudwatch:DescribeAlarms", "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics", "cloudwatch:ListMetrics",
          "dynamodb:DescribeTable", "dynamodb:List*", "dynamodb:DescribeTimeToLive", "dynamodb:DescribeContinuousBackups"
        ],
        Resource = "*"
      },
      {
        Sid    = "EC2ECRECSCognitoManagement",
        Effect = "Allow",
        Action = [
          "ec2:CreateTags", "ec2:DeleteTags", "ec2:RunInstances", "ec2:TerminateInstances", "ec2:StopInstances", "ec2:StartInstances", "ec2:RebootInstances",
          "ec2:CreateSecurityGroup", "ec2:DeleteSecurityGroup", "ec2:AuthorizeSecurityGroupIngress", "ec2:RevokeSecurityGroupIngress", "ec2:AuthorizeSecurityGroupEgress", "ec2:RevokeSecurityGroupEgress",
          "ec2:CreateKeyPair", "ec2:DeleteKeyPair", "ec2:ImportKeyPair", "ec2:CreateVolume", "ec2:DeleteVolume", "ec2:AttachVolume", "ec2:DetachVolume",
          "ec2:CreateSnapshot", "ec2:DeleteSnapshot", "ec2:CopySnapshot", "ec2:CreateImage", "ec2:DeregisterImage", "ec2:AllocateAddress", "ec2:ReleaseAddress", "ec2:AssociateAddress", "ec2:DisassociateAddress",
          "ec2:CreateSubnet", "ec2:DeleteSubnet", "ec2:ModifySubnetAttribute", "ec2:CreateVpc", "ec2:DeleteVpc", "ec2:ModifyVpcAttribute", "ec2:AssociateVpcCidrBlock", "ec2:DisassociateVpcCidrBlock",
          "ec2:CreateInternetGateway", "ec2:DeleteInternetGateway", "ec2:AttachInternetGateway", "ec2:DetachInternetGateway", "ec2:CreateRouteTable", "ec2:DeleteRouteTable", "ec2:CreateRoute", "ec2:DeleteRoute", "ec2:ReplaceRoute", "ec2:AssociateRouteTable", "ec2:DisassociateRouteTable",
          "ecr:CreateRepository", "ecr:DeleteRepository", "ecr:SetRepositoryPolicy", "ecr:DeleteRepositoryPolicy", "ecr:PutImageScanningConfiguration", "ecr:PutImageTagMutability", "ecr:TagResource", "ecr:UntagResource",
          "ecs:CreateCluster", "ecs:DeleteCluster", "ecs:CreateService", "ecs:UpdateService", "ecs:DeleteService", "ecs:RegisterTaskDefinition", "ecs:DeregisterTaskDefinition", "ecs:RunTask", "ecs:StopTask",
          "cognito-idp:CreateUserPool", "cognito-idp:UpdateUserPool", "cognito-idp:DeleteUserPool",
          "cognito-idp:CreateUserPoolClient", "cognito-idp:UpdateUserPoolClient", "cognito-idp:DeleteUserPoolClient",
          "cognito-idp:CreateUserPoolDomain", "cognito-idp:DeleteUserPoolDomain", "cognito-idp:UpdateUserPoolDomain",
          "cognito-idp:TagResource", "cognito-idp:UntagResource"
        ],
        Resource = "*"
      },
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
      },
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
        Resource = "arn:aws:dynamodb:us-east-1:*:table/${var.dynamodb_lock_table_name_for_policy}" # Assuming region and account
      },
      {
        Sid    = "IAMRoleManagement",
        Effect = "Allow",
        Action = [
          "iam:PassRole", 
          "iam:CreateRole", "iam:UpdateRole", "iam:DeleteRole", "iam:TagRole",
          "iam:CreatePolicy", "iam:DeletePolicy",
          "iam:AttachRolePolicy", "iam:DetachRolePolicy", 
          "iam:PutRolePolicy", "iam:DeleteRolePolicy"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_bucket_management_policy" {
  name        = "terraform_user_s3_bucket_management_policy"
  description = "Policy for S3 bucket management"
  
  tags = {
    Name = "terraform_user_s3_bucket_management_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3BucketFullAccess",
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "terraform_user_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.terraform_user_group_policy.arn
}

resource "aws_iam_group_policy_attachment" "s3_bucket_management_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.s3_bucket_management_policy.arn
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