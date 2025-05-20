# Terraform User Infrastructure

## Overview
Creates IAM user and group for Terraform operations with required permissions.

## Resources Created
- IAM user: `terraform_user`
- IAM group: `terraform_user_group`
- IAM policies for infrastructure management

## Quick Start
To create access key for terraform user:
```
aws iam create-access-key --user-name terraform_user
```

## Important Notes
- Uses S3 backend for state management
- Store access keys securely
- Never commit credentials to version control 