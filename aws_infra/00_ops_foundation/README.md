# AWS Operations Foundation

## Purpose
Establishes core infrastructure components required for all other AWS resources. Must be deployed first in the infrastructure sequence.

<details>
<summary><strong>Root Profile Configuration Process</strong></summary>

### Setting up AWS Root Account Profile
1. **Login to AWS Console**
   - Navigate to https://aws.amazon.com/console/
   - Sign in with root account credentials

2. **Create Root Access Keys**
   - Click your account name in top-right corner
   - Select "Security credentials"
   - Scroll to "Access keys" section
   - Click "Create access key"
   - Select "Root user access key" use case
   - Acknowledge security warnings
   - Download or securely copy credentials (only shown once)

3. **Configure AWS CLI Profile**
   - Ensure AWS CLI is installed (`aws --version`)
   - Run: `aws configure --profile root`
   - Enter prompted information:
     ```
     AWS Access Key ID: [YOUR_ROOT_ACCESS_KEY]
     AWS Secret Access Key: [YOUR_ROOT_SECRET_KEY]
     Default region: us-east-1
     Default output format: json
     ```

4. **Verify Configuration**
   - Test profile with: `aws sts get-caller-identity --profile root`
   - Should display your account ID and user ARN

5. **Using the Root Profile**
   - Either specify in commands: `aws s3 ls --profile root`
   - Or set environment variable: `export AWS_PROFILE=root`
</details>

<details>
<summary><strong>Terraform User Profile Setup</strong></summary>

1. **Create Access Keys** (after deploying terraform_user)
   - AWS Console → IAM → Users → terraform_user → Security credentials → Create access key
   - Use case: Command Line Interface
   - Download/copy credentials (shown once only)

2. **Configure Profile**
   - Run: `aws configure --profile terraform_user`
   - Enter the credentials when prompted
   - Same region as root profile (us-east-1)

3. **Use for Deployments**
   - `export AWS_PROFILE=terraform_user`
</details>

## Modules

<details>
<summary><strong>00_state_bucket</strong></summary>

- **Function**: Creates S3 bucket and DynamoDB table for Terraform state management
- **Dependencies**: None (first component to deploy)
- **Apply with**: Root AWS account credentials
- **Applied once**: Forms the foundation for all future infrastructure
</details>

<details>
<summary><strong>01_terraform_user</strong></summary>

- **Function**: Creates dedicated IAM user/group with appropriate permissions for Terraform operations
- **Dependencies**: 00_state_bucket (uses bucket for state storage)
- **Apply with**: Root AWS account credentials
- **Used by**: All subsequent infrastructure deployments
</details>

## Deployment Sequence
1. Deploy 00_state_bucket first (creates state management resources)
2. Deploy 01_terraform_user second (creates admin-like IAM resources)
3. Use terraform_user credentials for all subsequent infrastructure deployments

## Security Notes
- Root credentials should only be used for these foundational modules
- After terraform_user is created, switch to those credentials for all other infrastructure
- Treat state bucket resources as critical infrastructure (contains sensitive state)
- State resources have prevent_destroy and encryption enabled 