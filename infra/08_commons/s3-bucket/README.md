# S3 Bucket Module

S3 bucket with versioning, encryption, lifecycle management, and access controls.

## Configuration

```hcl
# terraform.tfvars
bucket_name = "my-app-assets"
enable_versioning = true      # Keep object versions
enable_encryption = true      # AES-256 encryption
block_public_access = true    # Prevent public access
enable_logging = false        # Access request logging
```

## Usage

### Upload Files
```bash
# Using service user credentials
aws s3 cp file.txt s3://my-app-assets/ --profile s3-svc
aws s3 sync ./local-folder s3://my-app-assets/folder/ --profile s3-svc
```

### Application Integration
```python
# Python boto3
import boto3

s3 = boto3.client('s3')

# Upload file
s3.upload_file('local_file.txt', 'my-app-assets', 'uploads/file.txt')

# Download file
s3.download_file('my-app-assets', 'uploads/file.txt', 'downloaded_file.txt')

# Generate presigned URL (1 hour expiry)
url = s3.generate_presigned_url('get_object', 
    Params={'Bucket': 'my-app-assets', 'Key': 'uploads/file.txt'}, 
    ExpiresIn=3600)
```

### Lifecycle Rules
```hcl
lifecycle_rules = [
  {
    id = "cleanup-old-versions"
    enabled = true
    prefix = ""
    expiration_days = 0                              # Keep current versions
    noncurrent_version_expiration_days = 90          # Delete old versions after 90 days
    noncurrent_version_transition_days = 30          # Move to IA after 30 days
    noncurrent_version_transition_storage_class = "STANDARD_IA"
  }
]
```

## Cost Optimization

- **Standard Storage**: $0.023/GB/month
- **Standard-IA**: $0.0125/GB/month (30+ days old)
- **Lifecycle transitions**: Move old versions to cheaper storage
- **Version cleanup**: Delete old versions to reduce costs

## Resources Created

- **S3 Bucket**: Main storage bucket
- **Versioning Configuration**: Optional object versioning
- **Server-Side Encryption**: AES-256 encryption for data at rest
- **Public Access Block**: Controls to prevent public access
- **Lifecycle Rules**: Automated object management
- **Access Logging**: Optional request logging

## Features

### Versioning

When `enable_versioning` is set to `true`, the bucket keeps multiple versions of each object, which protects against accidental deletion or overwrites.

### Encryption

When `enable_encryption` is set to `true`, all objects stored in the bucket are automatically encrypted using AES-256 encryption.

### Public Access Control

When `block_public_access` is set to `true`, the bucket blocks all public access, preventing objects from being exposed publicly.

### Lifecycle Rules

The module supports customizable lifecycle rules, which can:

- Automatically transition noncurrent object versions to cheaper storage classes
- Expire (delete) objects after a specified time period
- Set different rules for different object prefixes

### Access Logging

When `enable_logging` is set to `true`, the bucket logs all requests to objects, which is useful for auditing and security purposes.

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `app_name` | Application name used as prefix | string | "the-awesome-app" |
| `bucket_name` | Name of S3 bucket | string | "assets" |
| `enable_versioning` | Enable versioning | bool | true |
| `enable_encryption` | Enable encryption | bool | true |
| `block_public_access` | Block public access | bool | true |
| `enable_logging` | Enable access logging | bool | false |
| `lifecycle_rules` | Lifecycle rules configuration | list(object) | See variables file |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_id` | The name of the bucket |
| `bucket_arn` | The ARN of the bucket |
| `bucket_domain_name` | The bucket domain name |
| `bucket_regional_domain_name` | The bucket region-specific domain name |
| `versioning_status` | The versioning status of the bucket |
| `bucket_region` | The AWS region the bucket resides in | 