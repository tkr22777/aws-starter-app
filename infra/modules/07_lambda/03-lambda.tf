# IAM Role for the Lambda function to allow logging and SQS access
resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}-${var.environment}-${var.lambda_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.app_name}-${var.environment}-${var.lambda_name}-role"
  }
}

# Attach the AWS managed policy for Lambda basic execution
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Locals to determine SQS queue information
locals {
  # Use provided ARN or lookup result
  sqs_queue_arn = var.sqs_queue_arn != "" ? var.sqs_queue_arn : (
    length(data.aws_sqs_queue.target_queue) > 0 ? data.aws_sqs_queue.target_queue[0].arn : ""
  )

  # Use provided URL or lookup result  
  sqs_queue_url = var.sqs_queue_url != "" ? var.sqs_queue_url : (
    length(data.aws_sqs_queue.target_queue) > 0 ? data.aws_sqs_queue.target_queue[0].id : ""
  )

  # Extract queue name from ARN or use lookup result
  sqs_queue_name = var.sqs_queue_arn != "" ? regex("[^:]+$", var.sqs_queue_arn) : (
    length(data.aws_sqs_queue.target_queue) > 0 ? data.aws_sqs_queue.target_queue[0].name : var.sqs_queue_name
  )
}

# Policy to allow the Lambda function to read from the SQS queue
resource "aws_iam_policy" "lambda_sqs_policy" {
  name        = "${var.app_name}-${var.environment}-${var.lambda_name}-sqs-policy"
  description = "Allow Lambda to receive messages from SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = local.sqs_queue_arn
      }
    ]
  })
}

# Attach the SQS policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_sqs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_sqs_policy.arn
}

# Create a zip archive of the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/src/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Lambda function resource
resource "aws_lambda_function" "sqs_processor" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "${var.app_name}-${var.environment}-${var.lambda_name}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"

  # Use the hash of the file to detect changes and trigger updates
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime     = "python3.9"
  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  environment {
    variables = {
      QUEUE_NAME = local.sqs_queue_name
      QUEUE_URL  = local.sqs_queue_url
      DLQ_ARN    = var.dlq_arn
    }
  }

  tags = {
    Name = "${var.app_name}-${var.environment}-${var.lambda_name}"
  }
}

# Connect the Lambda to the SQS queue (only if queue ARN is available)
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  count            = local.sqs_queue_arn != "" ? 1 : 0
  event_source_arn = local.sqs_queue_arn
  function_name    = aws_lambda_function.sqs_processor.function_name
  batch_size       = var.batch_size
} 