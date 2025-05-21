# S3 Bucket Module

This module provisions an S3 bucket with configurable features including versioning, encryption, lifecycle rules, and public access controls.

## Resources Created

- **S3 Bucket**: Main storage bucket
- **Versioning Configuration**: Optional object versioning
- **Server-Side Encryption**: AES-256 encryption for data at rest
- **Public Access Block**: Controls to prevent public access
- **Lifecycle Rules**: Automated object management
- **Access Logging**: Optional request logging

## Usage

```hcl
module "s3_bucket" {
  source = "../08_commons/s3-bucket"
  
  app_name   = "your-app-name"
  bucket_name = "assets"
  
  # Optional configurations
  enable_versioning = true
  enable_encryption = true
  block_public_access = true
  enable_logging = false
  
  # Lifecycle rules
  lifecycle_rules = [
    {
      id                           = "default-rule"
      enabled                      = true
      prefix                       = ""
      expiration_days              = 0  # No expiration for current versions
      noncurrent_version_expiration_days = 90
      noncurrent_version_transition_days = 30
      noncurrent_version_transition_storage_class = "STANDARD_IA"
    },
    {
      id                           = "logs-rule"
      enabled                      = true
      prefix                       = "logs/"
      expiration_days              = 30
      noncurrent_version_expiration_days = 7
      noncurrent_version_transition_days = 0
      noncurrent_version_transition_storage_class = "STANDARD_IA"
    }
  ]
}
```

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