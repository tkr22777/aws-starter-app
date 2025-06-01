# Service Users Module

IAM users for external services to access AWS resources with least-privilege permissions.

## Configuration

```hcl
# terraform.tfvars
create_s3_user       = true   # S3 bucket access
create_sqs_user      = true   # SQS queue access
create_dynamodb_user = true   # DynamoDB table access
create_rds_user      = true   # RDS database access
create_combined_user = true   # Access to all services
```

## Setup AWS CLI Profiles

```bash
# Get credentials from Terraform outputs
terraform output s3_service_access_key_id
terraform output -raw s3_service_secret_access_key

# Configure AWS CLI profiles
aws configure --profile s3-svc
aws configure --profile sqs-svc
aws configure --profile dynamodb-svc
aws configure --profile combined-svc
```

## Usage Examples

### S3 Operations
```bash
# Upload/download files
aws s3 cp file.txt s3://my-app-assets/ --profile s3-svc
aws s3 cp s3://my-app-assets/file.txt ./downloaded.txt --profile s3-svc

# Sync directories
aws s3 sync ./local-folder s3://my-app-assets/folder/ --profile s3-svc
```

### SQS Operations
```bash
# Send/receive messages
aws sqs send-message --queue-url $(terraform output -raw queue_url) --message-body '{"data":"test"}' --profile sqs-svc
aws sqs receive-message --queue-url $(terraform output -raw queue_url) --profile sqs-svc
```

### DynamoDB Operations
```bash
# Put/get items
aws dynamodb put-item --table-name $(terraform output -raw table_name) --item '{"PK":{"S":"USER#123"},"name":{"S":"John"}}' --profile dynamodb-svc
aws dynamodb get-item --table-name $(terraform output -raw table_name) --key '{"PK":{"S":"USER#123"}}' --profile dynamodb-svc
```

### RDS Operations
```bash
# Generate IAM database token
auth_token=$(aws rds generate-db-auth-token --hostname $(terraform output -raw db_endpoint) --port 5432 --username postgres --profile rds-svc)

# Connect with token authentication
PGPASSWORD=$auth_token psql -h $(terraform output -raw db_endpoint) -p 5432 -U postgres -d postgres
```

## Application Integration

### Python Example
```python
import boto3

# Initialize service clients with profiles
session = boto3.Session(profile_name='s3-svc')
s3 = session.client('s3')

session = boto3.Session(profile_name='dynamodb-svc')
dynamodb = session.resource('dynamodb')

# Use resources
s3.upload_file('local_file.txt', 'my-app-assets', 'uploads/file.txt')
table = dynamodb.Table('my-app-main-table')
table.put_item(Item={'PK': 'USER#123', 'name': 'John'})
```

### Environment Variables
```bash
# Set credentials as environment variables
export AWS_ACCESS_KEY_ID=$(terraform output -raw s3_service_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(terraform output -raw s3_service_secret_access_key)
export AWS_DEFAULT_REGION=us-east-1
```

## Security Features

- **Least Privilege**: Each user only accesses required resources
- **Resource-Specific**: Permissions target specific ARNs
- **No Console Access**: Programmatic access only
- **Separate Credentials**: Independent keys per service
- **Combined Option**: Single user for multiple services 