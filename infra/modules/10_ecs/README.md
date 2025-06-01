# ECS Cluster with Public Load Balancer

Creates ECS cluster with Fargate, ALB, and auto-scaling using single subnet for ECS tasks.

## Resources Created

- ECS Cluster with Container Insights
- Application Load Balancer (public-facing, spans 2 AZs)
- ECS Service with Fargate launch type (single subnet)
- Minimal second subnet for ALB requirements only
- Auto Scaling (CPU/Memory based)
- CloudWatch logs
- Security groups (ALB + ECS tasks)
- IAM roles (execution + task)

## Configuration

```hcl
# terraform.tfvars
container_image = "nginx:latest"  # or your ECR image
desired_count   = 2
cpu            = 256
memory         = 512
```

## Usage

After deployment, access your application at the ALB DNS name:

```bash
# Get application URL
terraform output application_url

# Test the application
curl $(terraform output -raw application_url)

# Monitor service
aws ecs describe-services --cluster the-awesome-app-cluster --services the-awesome-app-service --profile terraform_user
```

## Architecture

- **Main Subnet**: All ECS tasks run in the primary subnet (us-east-1a)
- **ALB Subnets**: Load balancer spans main subnet + minimal second subnet (us-east-1b)
- **RDS Integration**: Shares ALB's second subnet for DB subnet group requirements

## Auto Scaling

- CPU target: 70%
- Memory target: 80%
- Min capacity: 1 task
- Max capacity: 10 tasks

## Security

- ALB accepts HTTP/HTTPS from internet
- ECS tasks only accept traffic from ALB
- All outbound traffic allowed for image pulls
- CloudWatch logging enabled 