# Lambda SQS Processor Module

Deploys a Lambda function with flexible SQS integration. The module can accept SQS queue information directly or lookup queues by name, making it reusable across different environments and naming conventions.

## Features

- **Flexible SQS Integration**: Accept queue ARN/URL directly or lookup by name
- **Conditional Event Source Mapping**: Only creates mapping when queue information is available
- **Environment Variables**: Automatically configures Lambda with queue details
- **IAM Permissions**: Proper SQS read permissions and Lambda execution role
- **Comprehensive Outputs**: ARNs, names, and CLI examples for testing

## Usage

### Direct SQS Queue Reference
```hcl
module "lambda" {
  source = "../../modules/07_lambda"
  
  app_name    = "my-app"
  environment = "prod"
  
  # Direct queue references
  sqs_queue_arn = "arn:aws:sqs:us-east-1:123456789012:my-queue"
  sqs_queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
  dlq_arn       = "arn:aws:sqs:us-east-1:123456789012:my-queue-dlq"
}
```

### Queue Lookup by Name
```hcl
module "lambda" {
  source = "../../modules/07_lambda"
  
  app_name    = "my-app"
  environment = "prod"
  
  # Lookup queue by name
  sqs_queue_name = "my-existing-queue"
}
```

### Remote State Integration
```hcl
data "terraform_remote_state" "sqs" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bucket"
    key    = "sqs/terraform.tfstate"
    region = "us-east-1"
  }
}

module "lambda" {
  source = "../../modules/07_lambda"
  
  app_name    = "my-app"
  environment = "prod"
  
  # Use outputs from SQS module
  sqs_queue_arn = data.terraform_remote_state.sqs.outputs.queue_arn
  sqs_queue_url = data.terraform_remote_state.sqs.outputs.queue_id
  dlq_arn       = data.terraform_remote_state.sqs.outputs.dlq_arn
}
```

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `app_name` | Application name for tagging | `string` | `"the-awesome-app"` |
| `environment` | Environment name | `string` | `"prod"` |
| `lambda_name` | Lambda function name | `string` | `"sqs-processor"` |
| `lambda_timeout` | Function timeout in seconds | `number` | `30` |
| `lambda_memory_size` | Memory allocation in MB | `number` | `128` |
| `sqs_queue_arn` | SQS queue ARN (optional) | `string` | `""` |
| `sqs_queue_url` | SQS queue URL (optional) | `string` | `""` |
| `sqs_queue_name` | SQS queue name for lookup (optional) | `string` | `""` |
| `dlq_arn` | Dead letter queue ARN (optional) | `string` | `""` |
| `batch_size` | SQS event source batch size | `number` | `10` |

## Outputs

| Name | Description |
|------|-------------|
| `lambda_function_name` | Lambda function name |
| `lambda_function_arn` | Lambda function ARN |
| `configured_sqs_queue_arn` | Configured SQS queue ARN |
| `event_source_mapping_enabled` | Whether event source mapping was created |
| `cli_invoke_example` | CLI command to test Lambda |
| `cli_logs_example` | CLI command to view logs |
| `cli_sqs_send_example` | CLI command to send test message |

## Architecture

The module creates:
- Lambda function with Python 3.9 runtime
- IAM role with SQS read permissions
- Event source mapping (if queue ARN provided)
- Environment variables for queue configuration

## Dependencies

- **Optional**: SQS queue (can be in same or different Terraform state)
- **Required**: IAM permissions for Lambda and SQS operations

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