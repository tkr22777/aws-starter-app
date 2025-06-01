# ECR Module

Elastic Container Registry (ECR) for Docker container image storage and management.

## Resources Created

- **ECR Repository**: Private Docker container registry with security scanning
- **Image Scanning**: Automatic vulnerability scanning on image push
- **Immutable Tags**: Prevents image tag overwriting for security

## Configuration

```hcl
# terraform.tfvars
app_name              = "the-awesome-app"
environment           = "development"
image_tag_mutability  = "IMMUTABLE"
scan_on_push         = true
```

## Usage

Deploy ECR:
```bash
cd infra/08_commons/ecr
terraform init
terraform plan
terraform apply
```

## Docker Integration

```bash
# Get login token and authenticate Docker
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <repository_url>

# Build and tag image
docker build -t <repository_url>:latest .

# Push image to ECR
docker push <repository_url>:latest
```

## Security Features

- **Image Scanning**: Vulnerabilities detected on push
- **Immutable Tags**: Prevents accidental overwriting
- **IAM Integration**: Fine-grained access control
- **Encryption**: Images encrypted at rest

## Cost Considerations

- **Storage**: Pay for storage of container images
- **Data Transfer**: Charges for pulling images across regions
- **Lifecycle Policies**: Consider implementing image cleanup policies

## Integration

Other modules can reference ECR outputs:
```hcl
# In other modules
data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "terraform-state-store-24680"
    key    = "ecr/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  ecr_url = data.terraform_remote_state.ecr.outputs.ecr_repository_url
}
``` 