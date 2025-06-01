# ALB Module

Shared Application Load Balancer for path-based routing between services.

## ⚠️ **CRITICAL: Network Module Dependency**

**This module depends on network module subnets. If network subnets change, ALB must be reapplied!**

**Safe workflow:**
```bash
# 1. Any network subnet changes
cd infra/02_network && terraform apply

# 2. ALWAYS reapply ALB after network changes  
cd ../02a_alb && terraform apply
```

**Dangerous operations:**
- Changing network subnet CIDR blocks
- Changing network availability zones
- Deleting/recreating network subnets

## Resources Created

- **ALB**: Internet-facing load balancer with default 404 response
- **Security Group**: HTTP/HTTPS ingress from internet, all egress
- **Target Group**: Default target group for health checks
- **Listener**: HTTP listener with path-based routing support

## Dependencies

- **Network Module**: VPC and subnets must exist first
- **Tags**: References network resources by Name tags

## Configuration

```hcl
# terraform.tfvars
app_name    = "the-awesome-app"
environment = "development"
```

## Usage

After deployment, other modules can register paths:
- EC2 module: `/api/*` paths
- ECS module: `/*` or custom paths

## Commands

Deploy ALB (takes 2-5 minutes):
```bash
cd infra/02a_alb
terraform init
terraform plan
terraform apply
```

Test ALB:
```bash
curl http://<alb-dns-name>
# Should return: Service not found (404)
``` 