# State Bucket Creation

## Overview
Creates the foundational S3 bucket and DynamoDB table for Terraform state management. This is a one-time setup.

## Prerequisites
- AWS account
- AWS CLI installed and configured with root credentials (temporary for setup only)

## Resources Created
- S3 bucket: `terraform-state-bucket`
- DynamoDB table: `terraform-state-locks`

## State Management Bootstrap Process
- Initial creation uses local state (chicken-and-egg problem)
- After resources exist, state migrates to the created S3 bucket
- Bucket eventually stores its own state (self-referential)
- Bootstrap steps:
  1. Start with backend block commented out
  2. Run initial `terraform apply` using local state
  3. Uncomment S3 backend configuration
  4. Run `terraform init` to migrate state to S3
  5. State now persists in the bucket it defines

### Example: Backend Configuration

**Step 1: Initially commented out (during resource creation)**
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  # backend "s3" {
  #   bucket         = "terraform-state-store-24680"
  #   key            = "00_ops_foundation/00_state_bucket/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-locks"
  # }
}
```

**Step 3: Uncommented (after resources exist)**
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "terraform-state-store-24680"
    key            = "00_ops_foundation/00_state_bucket/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
  }
}
```

## Troubleshooting State Mismatch Issues

### Problem: "state data in S3 does not have the expected content"
**Symptoms:** AWS resources exist but `terraform plan` fails with digest mismatch error.

**Root Cause:** S3 bucket and DynamoDB table exist but state file is missing/corrupted.

**Fix Process:**
```bash
# 1. Comment out backend block in 00-main.tf
# 2. Reset local state
rm -rf .terraform
terraform init

# 3. Import existing resources
terraform import aws_s3_bucket.terraform_state terraform-state-store-24680
terraform import aws_dynamodb_table.terraform_locks terraform-state-locks
terraform import aws_s3_bucket_public_access_block.terraform_state_public_access terraform-state-store-24680
terraform import aws_s3_bucket_versioning.terraform_state terraform-state-store-24680
terraform import aws_s3_bucket_server_side_encryption_configuration.terraform_state terraform-state-store-24680

# 4. Verify local state
terraform plan

# 5. Copy state to S3
aws s3 cp terraform.tfstate s3://terraform-state-store-24680/00_ops_foundation/00_state_bucket/terraform.tfstate --region us-east-1

# 6. Uncomment backend block in 00-main.tf
# 7. Get expected digest from error message
terraform init -reconfigure

# 8. Update DynamoDB with correct digest (use value from error)
aws dynamodb put-item --table-name terraform-state-locks --item '{"LockID":{"S":"terraform-state-store-24680/00_ops_foundation/00_state_bucket/terraform.tfstate-md5"},"Digest":{"S":"DIGEST_VALUE_FROM_ERROR"}}' --region us-east-1

# 9. Reconfigure backend
terraform init -reconfigure

# 10. Clean up local files
rm terraform.tfstate terraform.tfstate.backup
```

**Verification:** `terraform plan` should return "No changes. Your infrastructure matches the configuration."

## Important Notes
- This is a one-time setup
- Root credentials should only be used for this initial setup
- After creation, other modules will use this bucket for state storage

## Cleanup
If you need to destroy these resources (not recommended if other modules are using them):
`terraform destroy`