# AWS Infrastructure

Terraform modules for a complete AWS application stack with security, logging, and compliance features.

## Quick Start

1. **Setup AWS CLI**: Configure with root credentials initially
2. **Deploy Foundation**: State management and terraform user
3. **Deploy Infrastructure**: Application components in order
4. **Switch to Terraform User**: Use for ongoing operations

## Infrastructure Modules

| Order | Module | Purpose |
|-------|---------|---------|
| 00 | `ops_foundation/` | State bucket, terraform user, IAM policies |
| 01 | `cognito_user_pool/` | Authentication and user management |
| 02 | `network_ecr/` | VPC, subnets, container registry |
| 03 | `rds/` | PostgreSQL database |
| 04 | `ec2/` | Compute instances and key pairs |
| 05 | `ec2_rds/` | Connectivity between EC2 and RDS |
| 06 | `sqs/` | Message queues |
| 07 | `lambda/` | Serverless functions |
| 08 | `commons/` | Shared resources (CloudTrail, KMS, Logs, S3, DynamoDB, Secrets) |
| 09 | `svc_user/` | Service users for external access |

## Deployment

```bash
# 1. Foundation (use root AWS credentials)
cd infra/00_ops_foundation/00_state_bucket && terraform init && terraform apply
cd infra/00_ops_foundation/01_terraform_user && terraform init && terraform apply

# 2. Application Stack (use terraform_user credentials)
cd infra/01_cognito_user_pool && terraform init && terraform apply
cd infra/02_network_ecr && terraform init && terraform apply
cd infra/03_rds && terraform init && terraform apply
cd infra/04_ec2 && terraform init && terraform apply
cd infra/05_ec2_rds && terraform init && terraform apply
cd infra/06_sqs && terraform init && terraform apply
cd infra/07_lambda && terraform init && terraform apply

# 3. Commons (security, logging, storage)
cd infra/08_commons/cloudtrail && terraform init && terraform apply
cd infra/08_commons/kms && terraform init && terraform apply
cd infra/08_commons/cloudwatch-logs && terraform init && terraform apply
cd infra/08_commons/single-dynamodb-table && terraform init && terraform apply
cd infra/08_commons/s3-bucket && terraform init && terraform apply
cd infra/08_commons/secrets-manager && terraform init && terraform apply

# 4. Service Users
cd infra/09_svc_user && terraform init && terraform apply
```

## Configuration

Most modules use sensible defaults. Key customizations:

```hcl
# terraform.tfvars example
app_name = "my-app"
environment = "production"

# VPC configuration
vpc_cidr = "10.0.0.0/16"

# Database configuration
db_instance_class = "db.t3.micro"
db_allocated_storage = 20

# EC2 configuration
instance_type = "t3.micro"
```

## Usage Examples

### Database Connection
```bash
# Get connection details
terraform output -raw db_connection_string

# Connect via psql
psql -h $(terraform output -raw db_endpoint) -p 5432 -U postgres -d postgres
```

### S3 Operations
```bash
# List buckets
aws s3 ls --profile s3-svc

# Upload file
aws s3 cp file.txt s3://my-app-assets/ --profile s3-svc
```

### SQS Operations
```bash
# Send message
aws sqs send-message --queue-url $(terraform output -raw queue_url) --message-body '{"test":"data"}' --profile sqs-svc

# Receive messages
aws sqs receive-message --queue-url $(terraform output -raw queue_url) --profile sqs-svc
```

### DynamoDB Operations
```bash
# Put item
aws dynamodb put-item --table-name $(terraform output -raw table_name) --item '{"PK":{"S":"USER#123"},"SK":{"S":"PROFILE"},"name":{"S":"John"}}' --profile dynamodb-svc

# Get item
aws dynamodb get-item --table-name $(terraform output -raw table_name) --key '{"PK":{"S":"USER#123"},"SK":{"S":"PROFILE"}}' --profile dynamodb-svc
```

### CloudWatch Logs
```bash
# Tail application logs
aws logs tail /aws/my-app/app --follow --profile terraform_user

# Search for errors
aws logs filter-log-events --log-group-name /aws/my-app/app --filter-pattern ERROR --profile terraform_user
```

### Secrets Management
```bash
# Get secret
aws secretsmanager get-secret-value --secret-id my-secret --query SecretString --output text --profile terraform_user

# Update secret
aws secretsmanager update-secret --secret-id my-secret --secret-string "new-value" --profile terraform_user
```

## Security Features

- **CloudTrail**: Full audit logging
- **KMS**: Customer-managed encryption keys
- **IAM**: Least-privilege service users
- **VPC**: Private networking with security groups
- **Secrets Manager**: Secure credential storage

## Compliance

- SOC2, HIPAA, PCI-DSS, ISO 27001 ready
- Centralized logging and monitoring
- Encryption at rest and in transit
- Regular security scanning and updates