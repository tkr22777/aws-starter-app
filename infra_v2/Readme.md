# Infrastructure Setup Guide

## Overview
This repository contains Terraform configurations for setting up AWS infrastructure in three main components:
1. Operations Infrastructure (IAM users and permissions)
2. Authentication Infrastructure (Cognito)
3. Service Infrastructure (VPC, EC2, RDS, ECS)

## Infrastructure Components

### 1. Operations (`ops/`)
- State management user and permissions
- Terraform operations user and permissions
- S3 bucket and DynamoDB for terraform state

### 2. Authentication (`cognito-user-pool/`)
- User pool configuration
- Frontend client setup
- Email verification settings

### 3. Service (`service/`)
- VPC and networking
- EC2 instances and security groups
- RDS database setup
- ECR repositories
- ECS cluster

## Setup Steps

### 1. Initial Setup (using Root AWS Account)
1. Install prerequisites:
   - AWS CLI
   - Terraform
2. Configure AWS CLI with root credentials: `aws configure`
3. Create initial resources:
   - S3 bucket: `terraform-state-bucket`
   - DynamoDB table: `terraform-state-locks`
4. Setup state user:
   ```
   cd ops/state_user
   terraform init
   terraform apply
   ```
5. Create and securely store access keys for state user

### 2. Operations User Setup (using State User)
1. Configure AWS CLI with state user credentials
2. Setup terraform user:
   ```
   cd ops/terraform_user
   terraform init
   terraform import aws_iam_user.terraform_user terraform_user
   terraform apply
   ```
3. Create and securely store access keys for terraform user

### 3. Application Infrastructure (using Terraform User)
1. Configure AWS CLI with terraform user credentials
2. Deploy Cognito:
   ```
   cd cognito-user-pool
   terraform init
   terraform apply
   ```
3. Deploy service infrastructure:
   ```
   cd service
   terraform init
   terraform apply
   ```
4. Post-deployment steps:
   - Get service outputs: `terraform output -json > output.json`
   - Deploy application code:


## to refine commands to test postgres installation and list ec2 images

sudo yum install -y 
sudo yum -y module disable postgresql
sudo yum install -y postgresql15 postgresql15-server

sudo yum install postgresql.x86_64


aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
  --query "Images[*].[ImageId,Name,CreationDate]" \
  --output table


aws ec2 describe-images \
  --region us-east-1 \
  --owners 099720109477 \
  --query "Images[*].[ImageId,Name,CreationDate]" \
  --output table >> tmp.txt