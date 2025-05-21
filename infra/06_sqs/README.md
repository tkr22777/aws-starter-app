# SQS Queue Module

This module creates an Amazon SQS (Simple Queue Service) standard queue with configurable settings.

## Resources Created

- **Amazon SQS Queue** - A standard queue for message processing
- **Dead Letter Queue (Optional)** - Secondary queue for messages that fail processing
- **Queue Policies** - IAM policies controlling access to the queues

## Features

- Standard SQS queue
- Configurable message retention and visibility timeout
- Optional dead letter queue for failed messages
- Automatic policy configuration

## Usage

```hcl
module "sqs" {
  source = "../06_SQS"
  
  app_name   = "your-app-name"
  queue_name = "worker-tasks"
  
  # Optional configuration
  message_retention_seconds = 86400  # 1 day
  visibility_timeout_seconds = 60
  
  # Dead letter queue configuration
  create_dlq = true
  dlq_max_receive_count = 3
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `app_name` | Application name used as prefix | string | "the-awesome-app" |
| `queue_name` | Name of SQS queue | string | "main-queue" |
| `message_retention_seconds` | Message retention period | number | 345600 (4 days) |
| `visibility_timeout_seconds` | Visibility timeout | number | 30 |
| `create_dlq` | Create dead letter queue | bool | true |
| `dlq_max_receive_count` | Max receives before DLQ | number | 5 |

## Outputs

| Name | Description |
|------|-------------|
| `queue_id` | The URL of the SQS queue |
| `queue_arn` | The ARN of the SQS queue |
| `queue_name` | The name of the SQS queue |
| `dlq_id` | The URL of the dead-letter queue |
| `dlq_arn` | The ARN of the dead-letter queue |
| `dlq_name` | The name of the dead-letter queue |

## Best Practices

- For larger messages (>256KB), consider using S3 to store the message content
- Choose an appropriate visibility timeout based on your message processing time
- Use the dead letter queue to capture failed messages for analysis 