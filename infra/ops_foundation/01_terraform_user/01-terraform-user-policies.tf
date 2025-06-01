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
          "dynamodb:DescribeTable", "dynamodb:List*", "dynamodb:DescribeTimeToLive", "dynamodb:DescribeContinuousBackups"
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

# EC2, ECR, ECS, and Cognito management policy
resource "aws_iam_policy" "compute_services_policy" {
  name        = "terraform_user_compute_services_policy"
  description = "Policy for EC2, ECR, ECS, and Cognito services management"
  
  tags = {
    Name = "terraform_user_compute_services_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2Management",
        Effect = "Allow",
        Action = [
          "ec2:CreateTags", "ec2:DeleteTags", "ec2:RunInstances", "ec2:TerminateInstances", "ec2:StopInstances", "ec2:StartInstances", "ec2:RebootInstances",
          "ec2:CreateSecurityGroup", "ec2:DeleteSecurityGroup", "ec2:AuthorizeSecurityGroupIngress", "ec2:RevokeSecurityGroupIngress", "ec2:AuthorizeSecurityGroupEgress", "ec2:RevokeSecurityGroupEgress",
          "ec2:GetSecurityGroupsForVpc",
          "ec2:CreateKeyPair", "ec2:DeleteKeyPair", "ec2:ImportKeyPair", "ec2:CreateVolume", "ec2:DeleteVolume", "ec2:AttachVolume", "ec2:DetachVolume",
          "ec2:CreateSnapshot", "ec2:DeleteSnapshot", "ec2:CopySnapshot", "ec2:CreateImage", "ec2:DeregisterImage", "ec2:AllocateAddress", "ec2:ReleaseAddress", "ec2:AssociateAddress", "ec2:DisassociateAddress",
          "ec2:CreateSubnet", "ec2:DeleteSubnet", "ec2:ModifySubnetAttribute", "ec2:CreateVpc", "ec2:DeleteVpc", "ec2:ModifyVpcAttribute", "ec2:AssociateVpcCidrBlock", "ec2:DisassociateVpcCidrBlock",
          "ec2:CreateInternetGateway", "ec2:DeleteInternetGateway", "ec2:AttachInternetGateway", "ec2:DetachInternetGateway", "ec2:CreateRouteTable", "ec2:DeleteRouteTable", "ec2:CreateRoute", "ec2:DeleteRoute", "ec2:ReplaceRoute", "ec2:AssociateRouteTable", "ec2:DisassociateRouteTable"
        ],
        Resource = "*"
      },
      {
        Sid    = "ECRManagement",
        Effect = "Allow",
        Action = [
          "ecr:CreateRepository", "ecr:DeleteRepository", "ecr:SetRepositoryPolicy", "ecr:DeleteRepositoryPolicy", "ecr:PutImageScanningConfiguration", "ecr:PutImageTagMutability", "ecr:TagResource", "ecr:UntagResource",
          "ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload", "ecr:UploadLayerPart", "ecr:CompleteLayerUpload", "ecr:PutImage"
        ],
        Resource = "*"
      },
      {
        Sid    = "ECSManagement",
        Effect = "Allow",
        Action = [
          "ecs:CreateCluster", "ecs:DeleteCluster", "ecs:CreateService", "ecs:UpdateService", "ecs:DeleteService", "ecs:RegisterTaskDefinition", "ecs:DeregisterTaskDefinition", "ecs:RunTask", "ecs:StopTask",
          "ecs:TagResource", "ecs:UntagResource", "ecs:ListTagsForResource",
          "application-autoscaling:RegisterScalableTarget", "application-autoscaling:DeregisterScalableTarget", "application-autoscaling:DescribeScalableTargets",
          "application-autoscaling:PutScalingPolicy", "application-autoscaling:DeleteScalingPolicy", "application-autoscaling:DescribeScalingPolicies",
          "application-autoscaling:TagResource", "application-autoscaling:UntagResource", "application-autoscaling:ListTagsForResource"
        ],
        Resource = "*"
      },
      {
        Sid    = "CognitoManagement",
        Effect = "Allow",
        Action = [
          "cognito-idp:CreateUserPool", "cognito-idp:UpdateUserPool", "cognito-idp:DeleteUserPool",
          "cognito-idp:CreateUserPoolClient", "cognito-idp:UpdateUserPoolClient", "cognito-idp:DeleteUserPoolClient",
          "cognito-idp:CreateUserPoolDomain", "cognito-idp:DeleteUserPoolDomain", "cognito-idp:UpdateUserPoolDomain",
          "cognito-idp:TagResource", "cognito-idp:UntagResource"
        ],
        Resource = "*"
      }
    ]
  })
}

# RDS management policy
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

# DynamoDB management policy
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

# Application Load Balancer management policy
resource "aws_iam_policy" "alb_management_policy" {
  name        = "terraform_user_alb_management_policy"
  description = "Policy for Application Load Balancer management"
  
  tags = {
    Name = "terraform_user_alb_management_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ALBManagement",
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:DeleteRule",
          "elasticloadbalancing:ModifyRule",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags",
          "elasticloadbalancing:DescribeTags"
        ],
        Resource = "*"
      }
    ]
  })
}

# IAM management policy
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

resource "aws_iam_policy" "cloudtrail_policy" {
  name        = "terraform_user_cloudtrail_policy"
  description = "Policy for AWS CloudTrail and CloudWatch Logs management"
  
  tags = {
    Name = "terraform_user_cloudtrail_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudTrailManagement",
        Effect = "Allow",
        Action = [
          "cloudtrail:CreateTrail", "cloudtrail:DeleteTrail", "cloudtrail:UpdateTrail",
          "cloudtrail:DescribeTrails", "cloudtrail:GetTrailStatus", "cloudtrail:StartLogging", "cloudtrail:StopLogging",
          "cloudtrail:PutEventSelectors", "cloudtrail:GetEventSelectors", "cloudtrail:LookupEvents",
          "cloudtrail:ListTags", "cloudtrail:AddTags", "cloudtrail:RemoveTags"
        ],
        Resource = "*"
      },
      {
        Sid    = "CloudWatchLogsManagement",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup", "logs:DeleteLogGroup", "logs:DescribeLogGroups",
          "logs:CreateLogStream", "logs:DeleteLogStream", "logs:DescribeLogStreams",
          "logs:PutLogEvents", "logs:FilterLogEvents", "logs:GetLogEvents",
          "logs:PutRetentionPolicy", "logs:DeleteRetentionPolicy",
          "logs:TagLogGroup", "logs:UntagLogGroup", "logs:ListTagsLogGroup", "logs:ListTagsForResource",
          "logs:PutMetricFilter", "logs:DeleteMetricFilter", "logs:DescribeMetricFilters",
          "logs:PutSubscriptionFilter", "logs:DeleteSubscriptionFilter", "logs:DescribeSubscriptionFilters",
          "logs:PutQueryDefinition", "logs:DeleteQueryDefinition", "logs:DescribeQueryDefinitions",
          "logs:StartQuery", "logs:StopQuery", "logs:GetQueryResults",
          "logs:TestMetricFilter", "logs:Tail", "logs:GetLogRecord"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "kms_policy" {
  name        = "terraform_user_kms_policy"
  description = "Policy for AWS KMS key management"
  
  tags = {
    Name = "terraform_user_kms_policy"
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

resource "aws_iam_group_policy_attachment" "secrets_manager_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

resource "aws_iam_group_policy_attachment" "cloudtrail_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.cloudtrail_policy.arn
}

resource "aws_iam_group_policy_attachment" "kms_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.kms_policy.arn
}

resource "aws_iam_group_policy_attachment" "compute_services_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.compute_services_policy.arn
}

resource "aws_iam_group_policy_attachment" "rds_management_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.rds_management_policy.arn
}

resource "aws_iam_group_policy_attachment" "dynamodb_management_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.dynamodb_management_policy.arn
}

resource "aws_iam_group_policy_attachment" "iam_management_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.iam_management_policy.arn
}

resource "aws_iam_group_policy_attachment" "alb_management_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.alb_management_policy.arn
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