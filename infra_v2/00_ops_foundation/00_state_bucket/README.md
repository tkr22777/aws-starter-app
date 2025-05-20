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

## Important Notes
- This is a one-time setup
- Root credentials should only be used for this initial setup
- After creation, other modules will use this bucket for state storage

## Cleanup
If you need to destroy these resources (not recommended if other modules are using them):
`terraform destroy`