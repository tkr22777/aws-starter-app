# Network Infrastructure with Shared Load Balancer

Creates VPC, subnets, ECR repository, and shared Application Load Balancer.

## Resources Created

- VPC with Internet Gateway
- Public subnet (main workloads)
- Second public subnet (ALB requirement)
- ECR repository for container images
- Application Load Balancer (shared)
- ALB security group
- Route tables and associations

## File Organization

- `02-vpc.tf`: VPC, Internet Gateway, Route Table, ALB outputs
- `03-subnet.tf`: **All subnet definitions** (main + ALB subnets)
- `04-ecr.tf`: Container registry
- `05-alb.tf`: Application Load Balancer, Security Group, Target Group, Listener

## Architecture

- **Main Subnet**: `10.0.1.0/24` in `us-east-1a` (all workloads)
- **ALB Subnet**: `10.0.3.0/24` in `us-east-1b` (ALB spanning requirement)
- **Shared ALB**: Used by both EC2 and ECS modules

## Usage

The ALB supports path-based routing for different services:
- Default: Returns 404 for unmatched paths
- EC2 module: `/api/*` paths
- ECS module: `/*` or custom paths

```bash
# Test ALB directly
curl $(terraform output -raw application_url)

# Get ALB details
terraform output alb_dns_name
terraform output alb_arn
```

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
