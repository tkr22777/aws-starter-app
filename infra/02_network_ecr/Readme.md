# Network and ECR Infrastructure

Terraform configurations for the base network infrastructure and Elastic Container Registry (ECR).

## Network Resources Created
- VPC (CIDR: 10.0.0.0/16) with IPv4 and IPv6 support
- Public Subnet (CIDR: 10.0.1.0/24) in us-east-1a
- Internet Gateway
- Route Table with public routes

## ECR Resource Created

- **ECR Repository** (`aws_ecr_repository.app_ecr`)
  - Function: Provides a private Docker container registry to store, manage, and deploy Docker container images.
  - Relation: Used by services (e.g., ECS, EKS, or other container platforms) to pull application images for deployment. Essential for containerized application workflows.
  - Configuration: Image scanning on push is enabled for vulnerability detection; images are immutable to prevent overwriting.
