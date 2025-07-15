# =============================================================================
# Common Compute Services Management Policy
# =============================================================================

resource "aws_iam_policy" "common_compute_policy" {
  name        = "terraform_user_common_compute_policy"
  description = "Policy for shared compute services: CloudTrail, CloudWatch Logs, Lambda, Cognito, and Resource Groups"
  
  tags = {
    Name = "terraform_user_common_compute_policy"
  }
  
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
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

resource "aws_iam_group_policy_attachment" "common_compute_policy_attachment" {
  group      = aws_iam_group.terraform_user_group.name
  policy_arn = aws_iam_policy.common_compute_policy.arn
} 