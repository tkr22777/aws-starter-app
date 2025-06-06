# AWS Starter App

Production-ready AWS infrastructure using Terraform with modular architecture and environment-specific configurations.

## Architecture Overview

**Modular Design**: Each numbered directory represents a deployable unit with proper dependency ordering.

**Environment Isolation**: Separate configurations in `infra/environments/prod/` with dedicated state management.

**Configurable Modules**: Following standardized pattern with comprehensive variables, remote state integration, and production defaults.

## Module Status

### ✅ **Production Ready & Deployed**
- **01_cognito**: User authentication with Cognito User Pool
- **02_network**: VPC with multi-AZ subnets and IPv6 support
- **06_sqs**: Message queuing with DLQ and comprehensive policies
- **07_lambda**: SQS processing with flexible integration patterns

### ✅ **Refactored to Environment Pattern**
- **03_rds**: PostgreSQL database with encryption and configurable sizing
- **04_ec2**: Application servers with configurable instance types and storage
- **04a_ec2_alb**: ALB integration for EC2 instances with path-based routing
- **10_ecs**: Standalone ECS service with Fargate (single-task, direct IP)
- **10a_ecs_alb**: ECS ALB integration for high availability and load balancing

### 🔄 **Available Modules (Pending Environment Testing)**
- **02a_alb**: Application Load Balancer with SSL/TLS
- **05_ec2_rds**: Database connectivity and security groups
- **08_commons**: Shared security, logging, and storage
- **09_svc_user**: External service access with IAM

## Infrastructure Status

### ✅ **Completed**
- [x] SQS module with environment deployment and testing
- [x] Lambda module with flexible SQS integration (ARN, lookup, remote state)
- [x] End-to-end SQS→Lambda message processing verified
- [x] IAM terraform_user policies reorganized (10 service-specific policies)
- [x] All infrastructure follows engineering standards and best practices

### 🔄 **Next Steps: Production Environment Completion**

**Phase 1: Core Infrastructure**
- [ ] Deploy ALB environment (`02a_alb`)
- [ ] Deploy EC2-RDS connectivity (`05_ec2_rds`)
- [ ] Deploy Commons module (`08_commons`)
- [ ] Deploy Service Users (`09_svc_user`)

**Phase 2: Integration Testing**
- [ ] End-to-end application deployment test
- [ ] Database connectivity validation
- [ ] Load balancer health checks
- [ ] Message processing workflow testing

**Phase 3: Monitoring & Operations**
- [ ] CloudWatch dashboards and alerts
- [ ] Log aggregation and analysis
- [ ] Backup and disaster recovery procedures
- [ ] Performance optimization and cost analysis

## Recent Accomplishments

### SQS-Lambda Integration
- **Flexible Architecture**: Lambda supports direct ARN, name lookup, or remote state integration
- **Production Deployment**: Main queue + DLQ with proper policies and event source mapping
- **Verified Processing**: 1-2ms message processing latency with comprehensive logging
- **Standards Compliance**: All modules follow file organization, naming, and Terraform standards

### IAM Policy Optimization
- **Service Separation**: Split 549-line policy into 10 focused service policies
- **AWS Limit Compliance**: Exactly 10 policies (AWS maximum) with zero functionality loss
- **Enhanced Security**: Combined KMS+Secrets Manager, EC2+ECS+ECR logical groupings
- **Maintainability**: Clear separation of concerns for debugging and reviews

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
8. ✅ Messaging (SQS)
9. ✅ Serverless (Lambda)
10. 🔄 Commons (Security, Logging)
11. ✅ Container Service (ECS) - *Standalone module ready*
12. ✅ Container ALB (ECS-ALB) - *ALB integration module ready*
13. 🔄 Service Users (External Access)

## Development

Follow guidelines in `.cursorrules` for infrastructure standards, security practices, and deployment procedures.