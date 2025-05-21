# Infrastructure Setup Guide

## Overview
This repository contains Terraform configurations for AWS infrastructure organized into modular components:
1. Operations Foundation (IAM users and permissions)
2. Authentication (Cognito User Pool)
3. Network & Container Registry
4. Database (RDS)
5. Compute (EC2)
6. Connectivity (EC2-RDS)
7. Serverless Compute (Lambda)
8. Messaging (SQS)

## Infrastructure Components

### 1. Operations (`00_ops_foundation/`)
- **State Management (`00_state_bucket/`)**: S3 bucket and DynamoDB for terraform state
- **Terraform User (`01_terraform_user/`)**: IAM users and permissions for infrastructure management

### 2. Authentication (`01_cognito_user_pool/`)
- User pool configuration
- Client applications
- Authentication workflows

### 3. Network & Container Registry (`02_network_ecr/`)
- VPC configuration
- Subnets and routing
- Internet gateways
- ECR repositories for Docker images

### 4. Database (`03_rds/`)
- PostgreSQL RDS instance
- Database subnet groups
- Security groups for database access

### 5. Compute (`04_ec2/`)
- EC2 instances
- SSH key pair generation
- Security groups for compute access

### 6. Connectivity (`05_ec2_rds/`)
- Security group rules for EC2 to RDS connectivity
- Cross-module resource discovery

### 7. Serverless Compute (`07_lambda/`)
- Lambda functions for serverless processing
- IAM roles and policies
- Event source mappings for event-driven execution
- CloudWatch logging configuration

### 8. Messaging (`06_SQS/`)
- Standard SQS queues
- Optional dead-letter queues
- Queue access policies

## Setup Steps

### 1. Initial Setup (using Root AWS Account)
1. Install prerequisites:
   - AWS CLI
   - Terraform
2. Configure AWS CLI with root credentials: `aws configure`
3. Set up the operations foundation:
   ```
   cd infra/00_ops_foundation/00_state_bucket
   terraform init
   terraform apply
   ```
4. Create and securely store access keys for the state user

### 2. Operations User Setup (using State User)
1. Configure AWS CLI with state user credentials
2. Set up the terraform user:
   ```
   cd infra/00_ops_foundation/01_terraform_user
   terraform init
   terraform apply
   ```
3. Create and securely store access keys for the terraform user

### 3. Application Infrastructure (using Terraform User)
1. Configure AWS CLI with terraform user credentials
2. Deploy components in sequence:

   a. Authentication:
   ```
   cd infra/01_cognito_user_pool
   terraform init
   terraform apply
   ```

   b. Network & Container Registry:
   ```
   cd infra/02_network_ecr
   terraform init
   terraform apply
   ```

   c. Database:
   ```
   cd infra/03_rds
   terraform init
   terraform apply
   ```

   d. Compute:
   ```
   cd infra/04_ec2
   terraform init
   terraform apply
   ```

   e. Connectivity:
   ```
   cd infra/05_ec2_rds
   terraform init
   terraform apply
   ```

   f. Messaging:
   ```
   cd infra/06_SQS
   terraform init
   terraform apply
   ```

   g. Lambda:
   ```
   cd infra/07_lambda
   terraform init
   terraform apply
   ```

3. Access the infrastructure:
   - EC2 instance SSH access:
   ```
   terraform output -json ssh_connection_string
   ```
   - RDS connection string:
   ```
   terraform output -json db_connection_string
   ```

## Useful Commands

### Database
```bash
# Connect to PostgreSQL
psql -h <db_endpoint> -p 5432 -U postgres -d postgres
```

### EC2
```bash
# Install PostgreSQL client on Amazon Linux
sudo yum install -y postgresql15

# Install PostgreSQL client on Ubuntu
sudo apt-get update && sudo apt-get install -y postgresql-client
```

### Finding Ubuntu AMIs
```bash
# List recent Ubuntu 22.04 AMIs
aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
  --query "Images[*].[ImageId,Name,CreationDate]" \
  --output table
```

### SQS & Lambda
```bash
# Send a test message to SQS
aws sqs send-message --queue-url <queue_url> --message-body '{"test":"Hello, World!"}' --profile terraform_user

# View Lambda logs
aws logs filter-log-events --log-group-name /aws/lambda/<function_name> --profile terraform_user
```