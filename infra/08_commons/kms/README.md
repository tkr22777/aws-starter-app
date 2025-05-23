# AWS KMS Module

Comprehensive AWS KMS (Key Management Service) module for encryption keys management. Creates customer-managed encryption keys for different purposes with proper security configurations.

## Features

- **Multiple encryption keys** for different purposes (general, S3, database, secrets)
- **Key rotation enabled** by default for enhanced security
- **Multiple aliases** per key for easy reference
- **CloudTrail integration** for secrets key
- **Proper IAM policies** with least privilege
- **Modular design** - use only the keys you need

## Quick Start

```bash
cd infra/08_commons/kms
terraform init
terraform plan
terraform apply
```

## Created Resources

### Default Keys Created:
- **General Key** (`the-awesome-app-general-key`): General purpose application encryption
- **S3 Key** (`the-awesome-app-s3-key`): S3 bucket encryption  
- **Database Key** (`the-awesome-app-database-key`): RDS/DynamoDB encryption
- **Secrets Key** (`the-awesome-app-secrets-key`): Secrets Manager encryption

### Aliases Created:
- `alias/the-awesome-app-general`, `alias/the-awesome-app-app-data`
- `alias/the-awesome-app-s3`, `alias/the-awesome-app-bucket-encryption`
- `alias/the-awesome-app-database`, `alias/the-awesome-app-rds`, `alias/the-awesome-app-dynamodb`
- `alias/the-awesome-app-secrets`, `alias/the-awesome-app-secrets-manager`

## Integration Examples

### Using with S3 Bucket
```hcl
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.terraform_remote_state.kms.outputs.s3_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}
```

### Using with Secrets Manager
```hcl
resource "aws_secretsmanager_secret" "example" {
  name     = "my-secret"
  kms_key_id = data.terraform_remote_state.kms.outputs.secrets_key_id
}
```

### Using with RDS
```hcl
resource "aws_db_instance" "example" {
  # ... other configuration
  storage_encrypted = true
  kms_key_id       = data.terraform_remote_state.kms.outputs.database_key_id
}
```

## CLI Commands

After deployment, use these commands:

```bash
# List all KMS keys
aws kms list-keys --region us-east-1

# List all aliases
aws kms list-aliases --region us-east-1

# Describe a specific key
aws kms describe-key --key-id alias/the-awesome-app-general --region us-east-1

# Encrypt data
aws kms encrypt --key-id alias/the-awesome-app-general --plaintext "Hello World" --region us-east-1

# Decrypt data
aws kms decrypt --ciphertext-blob fileb://encrypted-file --region us-east-1
```

## Outputs

| Name | Description |
|------|-------------|
| `kms_key_ids` | Map of all KMS key IDs |
| `kms_key_arns` | Map of all KMS key ARNs |
| `general_key_id` | General purpose key ID |
| `s3_key_id` | S3 encryption key ID |
| `database_key_id` | Database encryption key ID |
| `secrets_key_id` | Secrets encryption key ID |

## Security Features

- **Customer-managed keys** (not AWS-managed)
- **Automatic key rotation** enabled (yearly)
- **Proper IAM policies** with root account access
- **CloudTrail logging** support for secrets key
- **30-day deletion window** for accidental deletion protection

## Cost Considerations

- **$1/month per key** (~$4/month total for default setup)
- **API usage charges** apply for encrypt/decrypt operations
- **Very cost-effective** for security benefits provided

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `app_name` | Application name | `string` | `"the-awesome-app"` |
| `environment` | Environment name | `string` | `"development"` |
| `kms_keys` | Map of keys to create | `map(object)` | 4 default keys |

## Compliance Notes

- **SOC2**: ✅ Encryption at rest requirement
- **HIPAA**: ✅ Data encryption requirement  
- **PCI-DSS**: ✅ Cardholder data encryption
- **ISO 27001**: ✅ Information security controls

## Dependencies

- AWS provider ~> 4.16
- S3 backend for state storage

## Integration Ready

This module works with:
- ✅ **All existing infrastructure** (zero disruption)
- ✅ **Future S3 buckets** (can use S3 key)
- ✅ **Future RDS instances** (can use database key)
- ✅ **Future DynamoDB tables** (can use database key)
- ✅ **Secrets Manager** (can use secrets key)
- ✅ **CloudTrail logs** (secrets key has CloudTrail permissions) 