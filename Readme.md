# AWS Starter App

Production-ready AWS infrastructure using Terraform with modular architecture and environment-specific configurations.

## Architecture Overview

**Modular Design**: Each numbered directory represents a deployable unit with proper dependency ordering.

**Environment Isolation**: Separate configurations in `infra/environments/prod/` with dedicated state management.

## Module Status

### ✅ **Tested & Deployed**
- **01_cognito**: User authentication with Cognito User Pool
- **02_network**: VPC with multi-AZ subnets and IPv6 support

### 🔄 **Available Modules (Pending Environment Testing)**
- **02a_alb**: Application Load Balancer with SSL/TLS
- **03_rds**: PostgreSQL database with encryption
- **04_ec2**: Application servers with IAM roles
- **05_ec2_rds**: Database connectivity and security groups
- **06_sqs**: Message queuing for async processing
- **07_lambda**: Serverless functions and triggers
- **08_commons**: Shared security, logging, and storage
- **09_svc_user**: External service access with IAM
- **10_ecs**: Container orchestration with Fargate

## Deployment Process

### Prerequisites
1. Deploy `00_ops_foundation/00_state_bucket` (root credentials)
2. Deploy `00_ops_foundation/01_terraform_user` (root credentials)
3. Switch to terraform-user credentials for all subsequent operations

### Environment Deployment
```bash
cd infra/environments/prod/{module_name}
terraform init
terraform plan
terraform apply
```

### Dependency Order
1. ✅ Authentication (Cognito)
2. ✅ Network (VPC, Subnets)
3. 🔄 Load Balancer (ALB)
4. 🔄 Database (RDS)
5. 🔄 Compute (EC2)
6. 🔄 Connectivity (EC2-RDS)
7. 🔄 Messaging (SQS)
8. 🔄 Serverless (Lambda)
9. 🔄 Commons (Security, Logging)
10. 🔄 Service Users (External Access)
11. 🔄 Container Orchestration (ECS)

## Next Steps

**Priority**: Complete environment testing for modules 02a_alb through 10_ecs following the dependency order.

**Goal**: Fully functional production environment with load balancing, database, container orchestration, and monitoring.

## Development

Follow guidelines in `.cursorrules` for infrastructure standards, security practices, and deployment procedures.