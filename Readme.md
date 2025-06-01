# AWS Starter App

Production-ready AWS infrastructure using Terraform with modular architecture and environment-specific configurations.

## Architecture Overview

**Modular Design**: Each numbered directory represents a deployable unit with proper dependency ordering.

**Environment Isolation**: Separate configurations in `infra/environments/prod/` with dedicated state management.

**Configurable Modules**: Following standardized pattern with comprehensive variables, remote state integration, and production defaults.

## Module Status

### ✅ **Tested & Deployed**
- **01_cognito**: User authentication with Cognito User Pool
- **02_network**: VPC with multi-AZ subnets and IPv6 support

### ✅ **Refactored to Environment Pattern**
- **03_rds**: PostgreSQL database with encryption and configurable sizing
- **04_ec2**: Application servers with configurable instance types and storage
- **04a_ec2_alb**: ALB integration for EC2 instances with path-based routing

### 🔄 **Available Modules (Pending Environment Testing)**
- **02a_alb**: Application Load Balancer with SSL/TLS
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
4. ✅ Database (RDS) - *Module refactored, environment ready*
5. ✅ Compute (EC2) - *Module refactored, environment ready*
6. ✅ ALB Integration (EC2-ALB) - *Separated module for clean architecture*
7. 🔄 Connectivity (EC2-RDS)
8. 🔄 Messaging (SQS)
9. 🔄 Serverless (Lambda)
10. 🔄 Commons (Security, Logging)
11. 🔄 Service Users (External Access)
12. 🔄 Container Orchestration (ECS)

## Recent Updates

### Infrastructure Improvements
- **RDS Module**: Refactored with configurable sizing, encryption defaults, and environment structure
- **EC2 Module**: Enhanced with instance type selection, storage configuration, and security settings
- **ALB Integration**: Separated into dedicated module for clean separation of concerns
- **Remote State**: All modules now use remote state for proper dependency management

### Environment Structure
All refactored modules follow standardized pattern:
- Production defaults optimized for cost and security
- Comprehensive variable organization with logical grouping
- Remote state integration between dependent modules
- Detailed outputs with CLI examples for operational use

## Next Steps

### 🎯 **Immediate Priority: End-to-End Testing**
Testing the complete deployment workflow for refactored modules:
1. Deploy RDS environment and verify connectivity
2. Deploy EC2 environment and confirm instance configuration
3. Deploy ALB integration and test load balancing
4. Validate inter-module state sharing and dependencies
5. Verify operational procedures (backup, monitoring, scaling)

### 🔄 **Module Conversion Pipeline**
Continue refactoring remaining modules to environment pattern:
- Modules 02a_alb through 10_ecs following dependency order
- Standardize variable organization and remote state integration
- Add production-optimized defaults and comprehensive outputs

**Goal**: Fully functional production environment with load balancing, database, container orchestration, and monitoring.

## Development

Follow guidelines in `.cursorrules` for infrastructure standards, security practices, and deployment procedures.