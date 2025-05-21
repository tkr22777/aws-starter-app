# Service Users Module

This module creates IAM users for services that need to interact with AWS resources. It's designed for services that may run outside of the AWS VPC (e.g., from a local machine, another cloud provider, or a serverless environment).

## Resources Created

- **Service-specific IAM Users:**
  - S3 Service User
  - SQS Service User
  - DynamoDB Service User
  - RDS Service User
  - Combined Service User (with access to all services)

- **IAM Policies:**
  - Service-specific policies with least privilege access
  - Access keys for programmatic access

## Purpose

These service users are designed for:
- External applications that need to access AWS resources
- Development environments outside AWS
- Services hosted on other cloud providers
- CI/CD pipelines that need to interact with AWS resources

## Security Considerations

The service users are configured with these security principles:
- **Least Privilege**: Each user only has access to specific resources they need
- **Resource-specific**: Permissions target specific resources by ARN
- **No console access**: Users are designed for programmatic access only
- **Independent credentials**: Separate credentials for each service type

## Usage

```hcl
module "service_users" {
  source = "../09_svc_user"
  
  app_name = "your-app-name"
  
  # Optional: Configure specific resource names
  s3_bucket_name      = "assets"
  sqs_queue_name      = "main-queue"
  dynamodb_table_name = "main-table"
  db_identifier       = "database"
  
  # Optional: Choose which users to create
  create_s3_user       = true
  create_sqs_user      = true
  create_dynamodb_user = true
  create_rds_user      = true
  create_combined_user = true
}
```

## Access Keys

After applying this module, you'll receive access keys for each service user. These should be securely stored and used for programmatic access:

```bash
# Example: Retrieve S3 user access key
terraform output s3_service_access_key_id
terraform output -raw s3_service_secret_access_key
```

## Command Line Usage

### Configuring AWS CLI Profiles

First, configure AWS CLI profiles for each service user:

```bash
# Configure S3 Service User
aws configure --profile s3-svc
# Enter the access key ID and secret access key when prompted
# Default region: us-east-1
# Default output format: json

# Configure SQS Service User
aws configure --profile sqs-svc
# Enter credentials when prompted

# Configure DynamoDB Service User
aws configure --profile dynamodb-svc
# Enter credentials when prompted

# Configure RDS Service User
aws configure --profile rds-svc
# Enter credentials when prompted

# Configure Combined Service User
aws configure --profile combined-svc
# Enter credentials when prompted
```

### S3 Service User Examples

```bash
# List objects in the bucket
aws s3 ls s3://the-awesome-app-assets/ --profile s3-svc

# Upload a file to the bucket
aws s3 cp myfile.txt s3://the-awesome-app-assets/ --profile s3-svc

# Download a file from the bucket
aws s3 cp s3://the-awesome-app-assets/myfile.txt ./downloaded-file.txt --profile s3-svc

# Delete an object from the bucket
aws s3 rm s3://the-awesome-app-assets/myfile.txt --profile s3-svc
```

### SQS Service User Examples

```bash
# Get the queue URL (needed for most operations)
queue_url=$(aws sqs get-queue-url --queue-name the-awesome-app-main-queue --profile sqs-svc --query 'QueueUrl' --output text)

# Send a message to the queue
aws sqs send-message --queue-url $queue_url --message-body '{"data":"test message"}' --profile sqs-svc

# Receive messages from the queue
aws sqs receive-message --queue-url $queue_url --max-number-of-messages 10 --profile sqs-svc

# Delete a message from the queue (requires receipt handle from receive-message)
aws sqs delete-message --queue-url $queue_url --receipt-handle "AQEBnhNM..." --profile sqs-svc
```

### DynamoDB Service User Examples

```bash
# Scan the table (list all items)
aws dynamodb scan --table-name the-awesome-app-main-table --profile dynamodb-svc

# Query the table (find items by key)
aws dynamodb query --table-name the-awesome-app-main-table \
  --key-condition-expression "PK = :pk" \
  --expression-attribute-values '{":pk": {"S":"USER#123"}}' \
  --profile dynamodb-svc

# Put an item into the table
aws dynamodb put-item --table-name the-awesome-app-main-table \
  --item '{"PK": {"S": "USER#123"}, "SK": {"S": "PROFILE"}, "name": {"S": "John Doe"}}' \
  --profile dynamodb-svc

# Get a specific item
aws dynamodb get-item --table-name the-awesome-app-main-table \
  --key '{"PK": {"S": "USER#123"}, "SK": {"S": "PROFILE"}}' \
  --profile dynamodb-svc

# Delete an item
aws dynamodb delete-item --table-name the-awesome-app-main-table \
  --key '{"PK": {"S": "USER#123"}, "SK": {"S": "PROFILE"}}' \
  --profile dynamodb-svc
```

### RDS Service User Examples

For RDS connections, the IAM user provides authentication to AWS, but you'll also need a database user configured in PostgreSQL:

```bash
# Generate an auth token for RDS IAM authentication
auth_token=$(aws rds generate-db-auth-token \
  --hostname the-awesome-app-database.xxxxxxx.us-east-1.rds.amazonaws.com \
  --port 5432 \
  --username postgres \
  --profile rds-svc)

# Connect to database using the token (requires SSL)
PGPASSWORD=$auth_token psql \
  -h the-awesome-app-database.xxxxxxx.us-east-1.rds.amazonaws.com \
  -p 5432 \
  -U postgres \
  -d postgres
```

### Combined Service User Examples

The combined service user can perform all the operations above:

```bash
# S3 Operations
aws s3 ls s3://the-awesome-app-assets/ --profile combined-svc

# SQS Operations
queue_url=$(aws sqs get-queue-url --queue-name the-awesome-app-main-queue --profile combined-svc --query 'QueueUrl' --output text)
aws sqs send-message --queue-url $queue_url --message-body '{"data":"test message"}' --profile combined-svc

# DynamoDB Operations
aws dynamodb scan --table-name the-awesome-app-main-table --profile combined-svc

# RDS Operations
auth_token=$(aws rds generate-db-auth-token \
  --hostname the-awesome-app-database.xxxxxxx.us-east-1.rds.amazonaws.com \
  --port 5432 \
  --username postgres \
  --profile combined-svc)
```

## Service User Permissions

### S3 Service User
- `s3:GetObject` - Retrieve objects from the bucket
- `s3:PutObject` - Upload objects to the bucket
- `s3:DeleteObject` - Remove objects from the bucket
- `s3:ListBucket` - List the contents of the bucket

### SQS Service User
- `sqs:SendMessage` - Send messages to the queue
- `sqs:ReceiveMessage` - Retrieve messages from the queue
- `sqs:DeleteMessage` - Remove messages from the queue
- `sqs:GetQueueAttributes` - View queue configuration
- `sqs:GetQueueUrl` - Retrieve the queue URL

### DynamoDB Service User
- `dynamodb:GetItem` - Read individual items
- `dynamodb:PutItem` - Write individual items
- `dynamodb:UpdateItem` - Modify existing items
- `dynamodb:DeleteItem` - Remove items
- `dynamodb:Query` - Query tables based on key attributes
- `dynamodb:Scan` - Scan full tables
- `dynamodb:BatchGetItem` - Retrieve multiple items
- `dynamodb:BatchWriteItem` - Write multiple items
- `dynamodb:DescribeTable` - View table configuration

### RDS Service User
- `rds-db:connect` - Connect to RDS instances

## Migrating Services Inside the VPC

When you migrate a service from outside the AWS VPC to inside the VPC, you should transition from using IAM users to using IAM roles. Here's how to approach this:

### 1. Create an IAM Role

Replace the IAM user with an IAM role that can be assumed by your service:

```hcl
resource "aws_iam_role" "service_role" {
  name = "${var.app_name}-service-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"  # For EC2
          # Or use "ecs-tasks.amazonaws.com" for ECS tasks
          # Or use "lambda.amazonaws.com" for Lambda
        }
      }
    ]
  })
}
```

### 2. Attach the Same Policies

Attach the same permissions to the role:

```hcl
resource "aws_iam_role_policy_attachment" "service_policy_attachment" {
  role       = aws_iam_role.service_role.name
  policy_arn = aws_iam_policy.service_policy.arn
}
```

### 3. For EC2 Instances

Create an instance profile:

```hcl
resource "aws_iam_instance_profile" "service_profile" {
  name = "${var.app_name}-service-profile"
  role = aws_iam_role.service_role.name
}
```

Then attach it to your EC2 instance:

```hcl
resource "aws_instance" "app_server" {
  # Other instance configuration...
  iam_instance_profile = aws_iam_instance_profile.service_profile.name
}
```

### 4. For ECS Tasks

Add the role to your task definition:

```hcl
resource "aws_ecs_task_definition" "service_task" {
  # Other task configuration...
  execution_role_arn = aws_iam_role.service_role.arn
  task_role_arn      = aws_iam_role.service_role.arn
}
```

### 5. For Lambda Functions

Attach the role to your Lambda function:

```hcl
resource "aws_lambda_function" "service_function" {
  # Other function configuration...
  role = aws_iam_role.service_role.arn
}
```

### 6. Update Service Configuration

Remove hardcoded AWS credentials from your application configuration. Services running inside the VPC with the attached IAM role will automatically obtain temporary credentials from the instance metadata service.

### 7. Security Group Considerations

When your service is inside the VPC, you may also need to configure security groups to allow traffic between the service and the AWS resources it accesses.

For example, to allow RDS access:

```hcl
resource "aws_security_group_rule" "service_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.service_sg.id
}
```

## Best Practices

1. **Rotate Keys Regularly**: Set up a process to rotate access keys
2. **Monitor Usage**: Enable CloudTrail and monitor for unexpected API calls
3. **Review Permissions**: Periodically review and refine permissions
4. **Use Condition Keys**: Consider adding condition keys to policies for additional security
5. **Transition to Roles**: When possible, transition from IAM users to IAM roles 