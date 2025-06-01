# Lambda SQS Processor Module

This module creates an AWS Lambda function that processes messages from an SQS queue.

## Resources Created

- **AWS Lambda Function**: Python function that processes SQS messages
- **IAM Role and Policies**: Permissions for Lambda to access CloudWatch Logs and SQS
- **Event Source Mapping**: Configuration connecting the Lambda to the SQS queue

## Features

- Automatic processing of SQS messages
- CloudWatch logging of message content
- JSON message parsing and formatting
- Configurable batch size and timeout settings

## Usage

```hcl
module "lambda" {
  source = "../07_lambda"
  
  app_name   = "your-app-name"
  lambda_name = "sqs-processor"
  queue_name = "main-queue"  # Should match the queue created in the SQS module
  
  # Optional configuration
  lambda_timeout = 60
  lambda_memory_size = 256
  batch_size = 5
}
```

## Prerequisites

This module requires:
- SQS queue to be created first (from the `06_SQS` module)

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `app_name` | Application name used as prefix | string | "the-awesome-app" |
| `lambda_name` | Name of the Lambda function | string | "sqs-processor" |
| `queue_name` | Name of the SQS queue to process | string | "main-queue" |
| `lambda_timeout` | The function execution timeout (seconds) | number | 30 |
| `lambda_memory_size` | The memory allocated to the function (MB) | number | 128 |
| `batch_size` | The number of messages to process in one batch | number | 10 |

## Outputs

| Name | Description |
|------|-------------|
| `lambda_function_name` | Name of the Lambda function |
| `lambda_function_arn` | ARN of the Lambda function |
| `lambda_role_arn` | ARN of the IAM role used by the Lambda |
| `event_source_mapping_id` | ID of the event source mapping |
| `connected_queue_name` | Name of the connected SQS queue |
| `logs_command` | Command to view the Lambda function logs |
| `invoke_command` | Command to manually invoke the Lambda function |

## How It Works

1. When a message is sent to the SQS queue, AWS Lambda automatically invokes the function
2. The Lambda function processes each message in the batch
3. The function logs the message body to CloudWatch
4. If the message is in JSON format, it parses and logs it with indentation
5. After successful processing, the message is automatically removed from the queue

## Testing

To test the Lambda function:
1. Send a message to the SQS queue
2. Wait for the Lambda to process it (usually within seconds)
3. Check the CloudWatch logs using the `logs_command` output

## Manual Invocation

You can manually invoke the Lambda with a test event using the `invoke_command` output. 