# AWS Infrastructure

Terraform modules for a modular, scalable AWS application stack with optimized deployment workflows.

<details>
<summary>⚙️ AWS Environment Setup & Verification</summary>

## Prerequisites Verification

### Check AWS CLI Installation
```bash
# Verify AWS CLI is installed and accessible
aws --version
# Expected: aws-cli/2.x.x or higher

# Check if jq is available for JSON parsing
jq --version
# Expected: jq-1.6 or higher (install with: brew install jq / apt-get install jq)
```

### Verify Root User Access
```bash
# Test root credentials are configured
aws sts get-caller-identity --profile root
# Expected: Should show your AWS account ID and root user ARN

# Check root user permissions for foundation setup
aws iam list-users --profile root --max-items 1
# Expected: Should list users without permission errors

# Verify S3 access for state bucket creation
aws s3 ls --profile root
# Expected: Should list buckets or show empty result (no permission errors)
```

### Verify Terraform Installation
```bash
# Check Terraform version
terraform version
# Expected: Terraform v1.5.x or compatible version

# Test terraform plan capability
cd infra/ops_foundation/00_state_bucket
terraform init -backend=false
terraform validate
# Expected: Configuration is valid
```

## AWS Credentials Configuration

### 1. Foundation Setup (Root Credentials)
```bash
# Configure root user profile for foundation-only deployment
aws configure --profile root
# AWS Access Key ID: [your-root-access-key]
# AWS Secret Access Key: [your-root-secret-key] 
# Default region name: us-east-1
# Default output format: json

# Verify root profile
aws sts get-caller-identity --profile root
```

### 2. Deploy Foundation Infrastructure
```bash
# Deploy state bucket (1-2 min)
cd infra/ops_foundation/00_state_bucket
terraform init
terraform plan
terraform apply

# Deploy terraform user (1 min)
cd ../01_terraform_user  
terraform init
terraform plan
terraform apply
```

### 3. Switch to Terraform User Credentials
```bash
# Get terraform_user credentials
cd infra/ops_foundation/01_terraform_user
terraform output terraform_user_access_key_id
terraform output terraform_user_secret_access_key

# Configure terraform profile
aws configure --profile terraform
# Access Key ID: [from terraform output above]
# Secret Access Key: [from terraform output above]
# Region: us-east-1
# Output format: json

# Set as default profile for infrastructure operations
export AWS_PROFILE=terraform

# Verify terraform user access
aws sts get-caller-identity
# Expected: Should show terraform_user ARN, NOT root
```

### 4. Verify Terraform User Permissions
```bash
# Test core infrastructure permissions
aws ec2 describe-vpcs --region us-east-1 --max-items 1
aws s3 ls
aws iam list-attached-user-policies --user-name terraform_user

# All commands should succeed without permission errors
```

## Deployment State Verification

### Quick Infrastructure Status
```bash
# Check what's deployed across all modules
find infra/environments/prod -name "*.tfstate" -exec basename {} \; | sort

# Count deployed resources
find infra/environments/prod -name "terraform.tfstate" -exec terraform show -json {} \; | jq '.values.root_module.resources | length' | paste -sd+ - | bc
```

### Detailed Module State
```bash
# Check specific module deployment
cd infra/environments/prod/{module_name}
terraform state list
terraform show -json | jq '.values.root_module.resources[].type' | sort | uniq -c

# Verify AWS resources match terraform state
aws sts get-caller-identity  # Confirm correct credentials
```

### AWS Resource Verification
```bash
# Core infrastructure audit
aws ec2 describe-vpcs --region us-east-1 --output table
aws ec2 describe-instances --region us-east-1 --output table  
aws rds describe-db-instances --region us-east-1 --output table
aws elbv2 describe-load-balancers --region us-east-1 --output table

# Check resource naming patterns
aws ec2 describe-vpcs --region us-east-1 --filters "Name=tag:Name,Values=*awesome-app*" --output table
```

</details>

<details>
<summary>🏗️ Architecture Philosophy</summary>

**Modular Design**: Each directory = deployable unit with specific purpose
**Dependency Chain**: Deploy in numerical order, fast modules separate from slow ones
**Shared Resources**: ALB and network infrastructure shared across services

</details>

<details>
<summary>📁 Directory Structure & Selection Guide</summary>

| Module | Deploy Time | Purpose | When to Use |
|--------|-------------|---------|-------------|
| `00_ops_foundation/` | 1-2 min | State bucket + terraform user | **Always required first** |
| `01_cognito_user_pool/` | 1-2 min | User authentication | Need user login/signup |
| `02_network/` | 30-45 sec | VPC, subnets, ECR | **Always required** |
| `02a_alb/` | 2-5 min | Shared load balancer | Need public web access |
| `03_rds/` | 5-10 min | PostgreSQL database | Need persistent data |
| `04_ec2/` | 1-2 min | Compute instances | Need traditional servers |
| `10_ecs/` | 1-2 min | Container orchestration | Need containerized apps |
| `08_commons/` | 1-3 min | Logging, security, storage | Production requirements |
| `09_svc_user/` | 30 sec | External access credentials | CI/CD or external integrations |

</details>

<details>
<summary>⚠️ CRITICAL: Module Dependencies</summary>

### **Network ↔ ALB Dependency**
**Problem**: Network subnet changes break ALB module
**Solution**: Subnets protected by `prevent_destroy = true`

```bash
# ❌ DANGEROUS: This breaks ALB
cd 02_network && terraform apply -var="subnet_cidr_block=10.0.2.0/24"

# ✅ SAFE: Intentional subnet change
cd 02_network && terraform apply -replace="aws_subnet.app_vpc_sn" -replace="aws_subnet.subnet_ha_2" 
cd 02a_alb && terraform apply  # REQUIRED after network changes
```

### **ALB ↔ Services Dependency**
EC2 and ECS modules register with shared ALB. Deploy ALB before services.

```bash
# ✅ CORRECT ORDER
02_network → 02a_alb → 04_ec2/10_ecs

# ❌ WILL FAIL
04_ec2 before 02a_alb (cannot find ALB)
```

</details>

<details>
<summary>🚀 Quick Start Workflows</summary>

### **Minimal Setup (Development)**
```bash
# Foundation (use root profile)
cd 00_ops_foundation/00_state_bucket && terraform init && terraform apply
cd ../01_terraform_user && terraform init && terraform apply

# Switch to terraform profile
export AWS_PROFILE=terraform

# Core Infrastructure
cd ../../02_network && terraform init && terraform apply      # 30s - Fast
cd ../02a_alb && terraform init && terraform apply           # 3min - Slow
cd ../04_ec2 && terraform init && terraform apply            # 1min - Medium

# Test
curl $(cd 02a_alb && terraform output -raw application_url)/api/
```

### **Production Setup**
```bash
# Add database and monitoring
cd 03_rds && terraform init && terraform apply               # 8min - Very slow
cd ../08_commons/cloudtrail && terraform init && terraform apply
cd ../cloudwatch-logs && terraform init && terraform apply
```

### **Container Workload**
```bash
# Replace/add EC2 with ECS
cd 10_ecs && terraform init && terraform apply               # 2min - Medium
curl $(cd 02a_alb && terraform output -raw application_url)/
```

</details>

<details>
<summary>🎯 Smart Module Selection</summary>

**Choose based on your needs:**

| Use Case | Required Modules | Optional Modules |
|----------|------------------|------------------|
| **Static Website** | `00`, `02`, `02a` | `08_commons` (logging) |
| **API Backend** | `00`, `02`, `02a`, `04_ec2`, `03_rds` | `08_commons`, `09_svc_user` |
| **Container App** | `00`, `02`, `02a`, `10_ecs` | `03_rds`, `08_commons` |
| **Full Production** | All modules | - |

</details>

<details>
<summary>🧪 Testing Commands</summary>

### **Network Connectivity**
```bash
# Test ALB health
curl $(cd 02a_alb && terraform output -raw application_url)
# Expected: "Service not found" (404) - ALB working, no services registered

# Test service paths
curl $(cd 02a_alb && terraform output -raw application_url)/api/    # → EC2
curl $(cd 02a_alb && terraform output -raw application_url)/        # → ECS
```

### **Database Connection**
```bash
# Quick connection test
cd 03_rds && psql $(terraform output -raw db_connection_string) -c "SELECT version();"
```

### **Container Deployment**
```bash
# Get ECR URL and push image
cd 02_network && echo $(terraform output -raw ecr_repo_url)
docker tag myapp:latest $(terraform output -raw ecr_repo_url):latest
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(terraform output -raw ecr_repo_url)
docker push $(terraform output -raw ecr_repo_url):latest
```

### **Auto-Scaling Test**
```bash
# Generate load to trigger scaling
hey -n 1000 -c 10 $(cd 02a_alb && terraform output -raw application_url)/api/
aws ecs describe-services --cluster the-awesome-app-cluster --services the-awesome-app-service --query 'services[0].desiredCount'
```

</details>

<details>
<summary>🏭 Production Considerations</summary>

### **Performance Optimization**
- **Fast deployment**: Keep network and ALB stable, iterate on services
- **Parallel deployment**: Network + RDS can deploy simultaneously  
- **Blue/green**: Use ECS for zero-downtime deployments

### **Cost Management**
- **Development**: Skip `08_commons`, use `t3.micro` instances
- **Production**: Enable CloudTrail, use reserved instances
- **Multi-environment**: Separate state buckets per environment

### **Security Best Practices**
- **Credentials**: Always use terraform_user after foundation setup
- **Networks**: Single subnet for simplicity, HA subnet auto-calculated
- **Encryption**: KMS keys in `08_commons` for production data

</details>

<details>
<summary>🛠️ Troubleshooting</summary>

### **Common Issues**
```bash
# ALB timing out
aws elbv2 describe-target-health --target-group-arn $(cd 02a_alb && terraform output -raw alb_arn)

# Service not responding  
aws ecs list-tasks --cluster the-awesome-app-cluster --service the-awesome-app-service
aws ecs describe-tasks --cluster the-awesome-app-cluster --tasks <task-id>

# Database connection failed
cd 03_rds && terraform output db_endpoint
aws rds describe-db-instances --db-instance-identifier the-awesome-app-db
```

### **Recovery Procedures**
```bash
# Reset ALB configuration
cd 02a_alb && terraform destroy && terraform apply

# Force ECS redeployment  
aws ecs update-service --cluster the-awesome-app-cluster --service the-awesome-app-service --force-new-deployment

# Unlock stuck state
terraform force-unlock <lock-id>  # Only with explicit approval
```

</details>

## 📋 Quick Reference

**Always deploy foundation first**: `00_ops_foundation/`
**Fast iteration**: Network (30s) → ALB (3min) → Services (1-2min)
**Critical dependency**: Network changes require ALB reapply
**Testing pattern**: `curl ALB → check logs → verify database`
**Production additions**: `08_commons/` for compliance and monitoring