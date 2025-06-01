# S3 Service User
resource "aws_iam_user" "s3_service_user" {
  count = var.create_s3_user ? 1 : 0
  name  = "${var.app_name}-s3-service-user"
  
  tags = {
    Name = "${var.app_name}-s3-service-user"
  }
}

resource "aws_iam_policy" "s3_service_policy" {
  count       = var.create_s3_user ? 1 : 0
  name        = "${var.app_name}-s3-service-policy"
  description = "Policy for S3 service access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3BucketAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.app_name}-${var.s3_bucket_name}",
          "arn:aws:s3:::${var.app_name}-${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "s3_service_policy_attachment" {
  count      = var.create_s3_user ? 1 : 0
  user       = aws_iam_user.s3_service_user[0].name
  policy_arn = aws_iam_policy.s3_service_policy[0].arn
}

# SQS Service User
resource "aws_iam_user" "sqs_service_user" {
  count = var.create_sqs_user ? 1 : 0
  name  = "${var.app_name}-sqs-service-user"
  
  tags = {
    Name = "${var.app_name}-sqs-service-user"
  }
}

resource "aws_iam_policy" "sqs_service_policy" {
  count       = var.create_sqs_user ? 1 : 0
  name        = "${var.app_name}-sqs-service-policy"
  description = "Policy for SQS service access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SQSQueueAccess"
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ]
        Resource = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.app_name}-${var.sqs_queue_name}"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "sqs_service_policy_attachment" {
  count      = var.create_sqs_user ? 1 : 0
  user       = aws_iam_user.sqs_service_user[0].name
  policy_arn = aws_iam_policy.sqs_service_policy[0].arn
}

# DynamoDB Service User
resource "aws_iam_user" "dynamodb_service_user" {
  count = var.create_dynamodb_user ? 1 : 0
  name  = "${var.app_name}-dynamodb-service-user"
  
  tags = {
    Name = "${var.app_name}-dynamodb-service-user"
  }
}

resource "aws_iam_policy" "dynamodb_service_policy" {
  count       = var.create_dynamodb_user ? 1 : 0
  name        = "${var.app_name}-dynamodb-service-policy"
  description = "Policy for DynamoDB service access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DynamoDBTableAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DescribeTable"
        ]
        Resource = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.app_name}-${var.dynamodb_table_name}"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "dynamodb_service_policy_attachment" {
  count      = var.create_dynamodb_user ? 1 : 0
  user       = aws_iam_user.dynamodb_service_user[0].name
  policy_arn = aws_iam_policy.dynamodb_service_policy[0].arn
}

# RDS Service User - Note that this is just for IAM authentication to RDS
# Database users must still be created within PostgreSQL itself
resource "aws_iam_user" "rds_service_user" {
  count = var.create_rds_user ? 1 : 0
  name  = "${var.app_name}-rds-service-user"
  
  tags = {
    Name = "${var.app_name}-rds-service-user"
  }
}

resource "aws_iam_policy" "rds_service_policy" {
  count       = var.create_rds_user ? 1 : 0
  name        = "${var.app_name}-rds-service-policy"
  description = "Policy for RDS service access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "RDSInstanceAccess"
        Effect = "Allow"
        Action = [
          "rds-db:connect"
        ]
        Resource = "arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:*/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "rds_service_policy_attachment" {
  count      = var.create_rds_user ? 1 : 0
  user       = aws_iam_user.rds_service_user[0].name
  policy_arn = aws_iam_policy.rds_service_policy[0].arn
}

# Combined Service User (access to all services)
resource "aws_iam_user" "combined_service_user" {
  count = var.create_combined_user ? 1 : 0
  name  = "${var.app_name}-combined-service-user"
  
  tags = {
    Name = "${var.app_name}-combined-service-user"
  }
}

resource "aws_iam_policy" "combined_service_policy" {
  count       = var.create_combined_user ? 1 : 0
  name        = "${var.app_name}-combined-service-policy"
  description = "Policy for combined service access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 Access
      {
        Sid    = "S3BucketAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.app_name}-${var.s3_bucket_name}",
          "arn:aws:s3:::${var.app_name}-${var.s3_bucket_name}/*"
        ]
      },
      # SQS Access
      {
        Sid    = "SQSQueueAccess"
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ]
        Resource = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.app_name}-${var.sqs_queue_name}"
      },
      # DynamoDB Access
      {
        Sid    = "DynamoDBTableAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DescribeTable"
        ]
        Resource = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.app_name}-${var.dynamodb_table_name}"
      },
      # RDS Access
      {
        Sid    = "RDSInstanceAccess"
        Effect = "Allow"
        Action = [
          "rds-db:connect"
        ]
        Resource = "arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:*/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "combined_service_policy_attachment" {
  count      = var.create_combined_user ? 1 : 0
  user       = aws_iam_user.combined_service_user[0].name
  policy_arn = aws_iam_policy.combined_service_policy[0].arn
}

# Access keys for all service users
resource "aws_iam_access_key" "s3_service_access_key" {
  count = var.create_s3_user ? 1 : 0
  user  = aws_iam_user.s3_service_user[0].name
}

resource "aws_iam_access_key" "sqs_service_access_key" {
  count = var.create_sqs_user ? 1 : 0
  user  = aws_iam_user.sqs_service_user[0].name
}

resource "aws_iam_access_key" "dynamodb_service_access_key" {
  count = var.create_dynamodb_user ? 1 : 0
  user  = aws_iam_user.dynamodb_service_user[0].name
}

resource "aws_iam_access_key" "rds_service_access_key" {
  count = var.create_rds_user ? 1 : 0
  user  = aws_iam_user.rds_service_user[0].name
}

resource "aws_iam_access_key" "combined_service_access_key" {
  count = var.create_combined_user ? 1 : 0
  user  = aws_iam_user.combined_service_user[0].name
} 