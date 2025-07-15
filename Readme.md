# AWS Starter App

Production-ready AWS infrastructure using Terraform with modular architecture and environment-specific configurations.

## Quick Start

**Prerequisites**: AWS CLI, Terraform 1.5+, and root AWS credentials
**Setup**: Follow AWS environment setup guide in [`infra/Readme.md`](infra/Readme.md)

```bash
# 1. Setup AWS credentials and deploy foundation (see infra/Readme.md)
cd infra && # follow AWS setup guide

# 2. Deploy core infrastructure
cd environments/prod/02_network && terraform init && terraform apply
cd ../02a_alb && terraform init && terraform apply
cd ../04_ec2 && terraform init && terraform apply

# 3. Test deployment
curl $(cd 02a_alb && terraform output -raw application_url)/api/
```

<details>
<summary>🏗️ Architecture Overview</summary>

**Modular Design**: Each numbered directory represents a deployable unit with proper dependency ordering.

**Environment Isolation**: Separate configurations in `infra/environments/prod/` with dedicated state management.

**Configurable Modules**: Following standardized pattern with comprehensive variables, remote state integration, and production defaults.

**Technology Stack**:
- **Infrastructure**: Terraform with AWS provider
- **Frontend**: React application with AWS Cognito authentication
- **Backend**: FastAPI with PostgreSQL database
- **Deployment**: EC2 and ECS with Application Load Balancer

</details>

<details>
<summary>📋 Module Status</summary>

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

</details>

<details>
<summary>🚀 Infrastructure Status</summary>

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

</details>

<details>
<summary>🏆 Recent Accomplishments</summary>

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

### Documentation Enhancement
- **Collapsible Sections**: Improved navigation with organized, expandable content
- **Application-Focused**: Added practical configuration guides and integration examples
- **Developer Experience**: Comprehensive setup verification and troubleshooting commands

</details>

<details>
<summary>🔧 Application Components</summary>

### Infrastructure (`infra/`)
- **Modular Terraform**: Environment-specific configurations with shared modules
- **AWS Foundation**: VPC, ALB, EC2, RDS, Cognito, SQS, Lambda
- **Security**: IAM policies, security groups, encryption at rest
- **Monitoring**: CloudTrail, CloudWatch logs, application metrics

### Frontend (`client/`)
- **React Application**: Modern SPA with TypeScript
- **Authentication**: AWS Cognito integration with hosted UI
- **Routing**: React Router with protected routes
- **State Management**: Context API for user authentication

### Backend (`api/`)
- **FastAPI Framework**: High-performance Python API
- **Database Integration**: PostgreSQL with SQLAlchemy ORM
- **Authentication**: JWT token validation from Cognito
- **Docker Support**: Containerized deployment

### Deployment Order
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

</details>

## Development

### Directory Structure
- **`infra/`**: Complete AWS infrastructure with Terraform modules
- **`client/`**: React frontend application
- **`api/`**: FastAPI backend application

### Getting Started
1. **Infrastructure**: Follow setup guide in [`infra/Readme.md`](infra/Readme.md)
2. **Frontend**: See instructions in [`client/README.md`](client/README.md)
3. **Backend**: See setup in [`api/Readme.md`](api/Readme.md)

### Engineering Standards
Follow guidelines in [`.cursorrules`](.cursorrules) for infrastructure standards, security practices, and deployment procedures.