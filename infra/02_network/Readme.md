# Network Module

Core networking infrastructure with VPC, subnets, and ECR repository.

## ⚠️ **CRITICAL: Subnet Change Impact**

**Changing subnet CIDR or AZ will break the ALB module!**

To change subnets:

1. **Plan carefully**: Subnet changes recreate ALB (5+ min downtime)
2. **Coordinate modules**: Apply network first, then ALB
3. **Test thoroughly**: Verify subnet connectivity after changes

```bash
# Example: Changing subnet configuration
cd infra/02_network
terraform plan  # Review changes first
terraform apply

# REQUIRED: Update ALB after subnet changes
cd ../02a_alb  
terraform apply
```

## Resources Created

- **VPC**: Virtual Private Cloud with IPv4/IPv6 support
- **Subnets**: Main workload subnet + HA subnet for multi-AZ services
- **Internet Gateway**: Public internet connectivity
- **Route Tables**: Routing for internet traffic
- **ECR Repository**: Container registry for Docker images

## Architecture

- **Main Subnet**: Configurable via `subnet_cidr_block` and `availability_zone`
- **HA Subnet**: Configurable via `subnet_ha_2_cidr_block` and `subnet_ha_2_availability_zone`

## Dependencies

Deploy **before** ALB module - ALB references subnets by tags.

## Configuration

```hcl
# terraform.tfvars
app_name                       = "the-awesome-app"
environment                    = "development"
vpc_cidr_block                 = "10.0.0.0/16"
subnet_cidr_block              = "10.0.1.0/24"
availability_zone              = "us-east-1a"
subnet_ha_2_cidr_block         = "10.0.3.0/24"
subnet_ha_2_availability_zone  = "us-east-1b"
```

## Commands

Deploy network (fast - ~30 seconds):
```bash
cd infra/02_network
terraform init
terraform plan
terraform apply
```

## File Organization

- `02-vpc.tf`: VPC, Internet Gateway, Route Table
- `03-subnet.tf`: Subnet definitions and associations
- `04-ecr.tf`: Container registry

## Usage

Provides foundational networking for all other modules.

## Network Resources Created
- VPC (CIDR: 10.0.0.0/16) with IPv4 and IPv6 support
- Public Subnet (CIDR: 10.0.1.0/24) in us-east-1a
- HA Subnet (CIDR: 10.0.3.0/24) in us-east-1b
- Internet Gateway
- Route Table with public routes

## ECR Resource Created

- **ECR Repository** (`aws_ecr_repository.app_ecr`)
  - Function: Provides a private Docker container registry to store, manage, and deploy Docker container images.
  - Relation: Used by services (e.g., ECS, EKS, or other container platforms) to pull application images for deployment. Essential for containerized application workflows.
  - Configuration: Image scanning on push is enabled for vulnerability detection; images are immutable to prevent overwriting.
