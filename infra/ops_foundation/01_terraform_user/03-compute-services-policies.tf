# =============================================================================
# Compute Services Management Policy
# =============================================================================

resource "aws_iam_policy" "compute_services_policy" {
  name        = "terraform_user_compute_services_policy"
  description = "Policy for EC2, ECR, ECS, Cognito, CloudTrail, Lambda, and Resource Groups tagging services management"
  
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
          "ec2:CreateTags", "ec2:DeleteTags", "ec2:RunInstances",
          "ec2:TerminateInstances", "ec2:StopInstances", "ec2:StartInstances",
          "ec2:RebootInstances", "ec2:CreateSecurityGroup", "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress", "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress", "ec2:RevokeSecurityGroupEgress",
          "ec2:GetSecurityGroupsForVpc", "ec2:CreateKeyPair", "ec2:DeleteKeyPair",
          "ec2:ImportKeyPair", "ec2:CreateVolume", "ec2:DeleteVolume",
          "ec2:AttachVolume", "ec2:DetachVolume", "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot", "ec2:CopySnapshot", "ec2:CreateImage",
          "ec2:DeregisterImage", "ec2:AllocateAddress", "ec2:ReleaseAddress",
          "ec2:AssociateAddress", "ec2:DisassociateAddress", "ec2:CreateSubnet",
          "ec2:DeleteSubnet", "ec2:ModifySubnetAttribute", "ec2:CreateVpc",
          "ec2:DeleteVpc", "ec2:ModifyVpcAttribute", "ec2:AssociateVpcCidrBlock",
          "ec2:DisassociateVpcCidrBlock", "ec2:CreateInternetGateway",
          "ec2:DeleteInternetGateway", "ec2:AttachInternetGateway",
          "ec2:DetachInternetGateway", "ec2:CreateRouteTable", "ec2:DeleteRouteTable",
          "ec2:CreateRoute", "ec2:DeleteRoute", "ec2:ReplaceRoute",
          "ec2:AssociateRouteTable", "ec2:DisassociateRouteTable"
        ],
        Resource = "*"
      },
      {
        Sid    = "ECRManagement",
        Effect = "Allow",
        Action = [
          "ecr:CreateRepository", "ecr:DeleteRepository", "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy", "ecr:PutImageScanningConfiguration",
          "ecr:PutImageTagMutability", "ecr:TagResource", "ecr:UntagResource",
          "ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart", "ecr:CompleteLayerUpload", "ecr:PutImage"
        ],
        Resource = "*"
      },
      {
        Sid    = "ECSManagement",
        Effect = "Allow",
        Action = [
          "ecs:CreateCluster", "ecs:DeleteCluster", "ecs:CreateService",
          "ecs:UpdateService", "ecs:DeleteService", "ecs:RegisterTaskDefinition",
          "ecs:DeregisterTaskDefinition", "ecs:RunTask", "ecs:StopTask",
          "ecs:TagResource", "ecs:UntagResource", "ecs:ListTagsForResource",
          "application-autoscaling:RegisterScalableTarget",
          "application-autoscaling:DeregisterScalableTarget",
          "application-autoscaling:DescribeScalableTargets",
          "application-autoscaling:PutScalingPolicy",
          "application-autoscaling:DeleteScalingPolicy",
          "application-autoscaling:DescribeScalingPolicies",
          "application-autoscaling:TagResource",
          "application-autoscaling:UntagResource",
          "application-autoscaling:ListTagsForResource"
        ],
        Resource = "*"
      },
      {
        Sid    = "CognitoManagement",
        Effect = "Allow",
        Action = [
          "cognito-idp:CreateUserPool", "cognito-idp:UpdateUserPool",
          "cognito-idp:DeleteUserPool", "cognito-idp:CreateUserPoolClient",
          "cognito-idp:UpdateUserPoolClient", "cognito-idp:DeleteUserPoolClient",
          "cognito-idp:CreateUserPoolDomain", "cognito-idp:DeleteUserPoolDomain",
          "cognito-idp:UpdateUserPoolDomain", "cognito-idp:TagResource",
          "cognito-idp:UntagResource"
        ],
        Resource = "*"
      },
      {
        Sid    = "CloudTrailManagement",
        Effect = "Allow",
        Action = [
          "cloudtrail:ListTrails",
          "cloudtrail:CreateTrail", "cloudtrail:DeleteTrail", "cloudtrail:UpdateTrail",
          "cloudtrail:DescribeTrails", "cloudtrail:GetTrailStatus", "cloudtrail:StartLogging",
          "cloudtrail:StopLogging", "cloudtrail:PutEventSelectors", "cloudtrail:GetEventSelectors",
          "cloudtrail:LookupEvents", "cloudtrail:ListTags", "cloudtrail:AddTags", "cloudtrail:RemoveTags"
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
          "logs:TagLogGroup", "logs:UntagLogGroup", "logs:ListTagsLogGroup",
          "logs:ListTagsForResource", "logs:PutMetricFilter", "logs:DeleteMetricFilter",
          "logs:DescribeMetricFilters", "logs:PutSubscriptionFilter",
          "logs:DeleteSubscriptionFilter", "logs:DescribeSubscriptionFilters",
          "logs:PutQueryDefinition", "logs:DeleteQueryDefinition",
          "logs:DescribeQueryDefinitions", "logs:StartQuery", "logs:StopQuery",
          "logs:GetQueryResults", "logs:TestMetricFilter", "logs:Tail",
          "logs:GetLogRecord"
        ],
        Resource = "*"
      },
      {
        Sid    = "LambdaManagement",
        Effect = "Allow",
        Action = [
          "lambda:ListFunctions", "lambda:GetFunction", "lambda:CreateFunction",
          "lambda:DeleteFunction", "lambda:UpdateFunctionCode", "lambda:UpdateFunctionConfiguration",
          "lambda:ListVersionsByFunction", "lambda:PublishVersion", "lambda:CreateAlias",
          "lambda:DeleteAlias", "lambda:UpdateAlias", "lambda:GetAlias", "lambda:ListAliases",
          "lambda:AddPermission", "lambda:RemovePermission", "lambda:GetPolicy",
          "lambda:TagResource", "lambda:UntagResource", "lambda:ListTags",
          "lambda:CreateEventSourceMapping", "lambda:DeleteEventSourceMapping",
          "lambda:GetEventSourceMapping", "lambda:ListEventSourceMappings",
          "lambda:UpdateEventSourceMapping", "lambda:InvokeFunction",
          "lambda:GetFunctionCodeSigningConfig"
        ],
        Resource = "*"
      },
      {
        Sid    = "ResourceGroupsTagging",
        Effect = "Allow",
        Action = [
          "tag:GetResources", "tag:GetTagKeys", "tag:GetTagValues",
          "tag:TagResources", "tag:UntagResources"
        ],
        Resource = "*"
      }
    ]
  })
}

# =============================================================================
# Policy Attachment
# =============================================================================

resource "aws_iam_group_policy_attachment" "compute_services_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.compute_services_policy.arn
} 