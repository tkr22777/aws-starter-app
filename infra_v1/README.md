# AWS Infrastructure Management Guide

## Setting Up AWS Access

### Root Account Access Keys
1. Sign in to AWS Management Console with root credentials
2. Click your account name (top-right) → Security credentials
3. Under "Access keys", click "Create access key"
4. Select "Root user access key" use case, acknowledge the risk
5. Download or securely copy the key pair (shown only once)
6. Configure locally: `aws configure`
   ```
   AWS Access Key ID: [YOUR_ROOT_ACCESS_KEY]
   AWS Secret Access Key: [YOUR_ROOT_SECRET_KEY]
   Default region: us-east-2
   Default output format: json
   ```

### Creating terraform_user (One-time setup)
1. Using root credentials, navigate to the ops directory:
   ```
   cd infra/ops
   terraform apply -auto-approve
   ```
2. This creates:
   - IAM user: terraform_user
   - IAM group: terraform_user_group
   - Policy with permissions for infrastructure management

### Creating terraform_user Access Keys
1. Sign in to AWS Console (with root or admin)
2. Navigate to IAM → Users → terraform_user
3. Security credentials tab → Create access key
4. Select "Command Line Interface (CLI)" use case
5. Download or securely copy the key pair

## Switching Between AWS Credential Profiles

### Using Named Profiles
1. Configure multiple profiles:
   ```
   aws configure --profile root
   aws configure --profile terraform_user
   ```

2. Use specific profile for AWS CLI commands:
   ```
   aws s3 ls --profile terraform_user
   ```

3. Use profile for Terraform operations:
   ```
   # In ~/.aws/config ensure profiles are configured
   # In terminal before running terraform:
   export AWS_PROFILE=terraform_user
   
   # Then run terraform commands
   cd infra/service
   terraform apply
   ```

4. Alternatively, specify profile in Terraform files:
   ```
   provider "aws" {
     profile = "terraform_user"
     region  = "us-east-2"
   }
   ```

## Infrastructure Directories

- `/infra/ops`: Root account resources - IAM users, groups, base permissions
- `/infra/service`: Application infrastructure components
- `/infra/cognito-user-pool`: User authentication resources

## Best Practices

- Use root credentials only for initial setup and emergency recovery
- Perform regular infrastructure updates with terraform_user
- Store your terraform state securely
- Consider using AWS SSO for more advanced credential management 