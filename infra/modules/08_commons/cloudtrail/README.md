# AWS CloudTrail Module

Comprehensive AWS CloudTrail module for audit logging and compliance. This module creates a CloudTrail with S3 storage, optional CloudWatch Logs integration, and proper security configurations.

## Features

- **Multi-region CloudTrail** with global service events
- **S3 bucket** with versioning, encryption, and lifecycle policies
- **CloudWatch Logs** integration (optional)
- **Log file validation** for integrity checking
- **Configurable data events** for S3, DynamoDB, etc.
- **Cost-optimized** with automatic archival to IA/Glacier
- **Security best practices** with proper IAM permissions

## Quick Start

```bash
cd infra/08_commons/cloudtrail
terraform init
terraform plan
terraform apply
```

## Configuration

### Basic Usage
```hcl
# Uses all default settings - good for most use cases
```

### Advanced Configuration
```hcl
# terraform.tfvars
app_name = "my-app"
environment = "production"

# Extend log retention for compliance
log_retention_days = 365
archive_transition_days = 90
glacier_transition_days = 180

# Enable S3 data events monitoring
event_selector = {
  data_resource = [
    {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::my-bucket/*"]
    }
  ]
}

# Use custom KMS key for encryption
kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
```

## Resources Created

- `aws_cloudtrail` - The main CloudTrail
- `aws_s3_bucket` - CloudTrail logs storage
- `aws_s3_bucket_*` - Bucket security and lifecycle configurations
- `aws_cloudwatch_log_group` - CloudWatch logs (optional)
- `aws_iam_role` - CloudWatch logs role (optional)
- `aws_iam_role_policy` - CloudWatch permissions (optional)

## Outputs

| Name | Description |
|------|-------------|
| `cloudtrail_arn` | ARN of the CloudTrail |
| `s3_bucket_name` | S3 bucket name for logs |
| `cloudwatch_log_group_name` | CloudWatch log group name |
| `aws_cli_commands` | Useful CLI commands |

## CLI Commands

After deployment, use these commands to interact with CloudTrail:

```bash
# View CloudTrail status
aws cloudtrail get-trail-status --name the-awesome-app-cloudtrail

# Look up recent events
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=CreateUser --start-time $(date -d '24 hours ago' --iso-8601)

# List S3 log files
aws s3 ls s3://$(terraform output -raw s3_bucket_name)/ --recursive

# View recent CloudWatch logs (if enabled)
aws logs filter-log-events --log-group-name $(terraform output -raw cloudwatch_log_group_name) --start-time $(date -d '1 hour ago' +%s)000
```

## Security Features

- **S3 bucket encryption** (AES256 or KMS)
- **Bucket versioning** enabled
- **Public access blocked** on S3 bucket
- **Log file validation** for tamper detection
- **Least privilege IAM** for CloudWatch integration
- **VPC endpoint ready** for private connectivity

## Cost Optimization

- **Lifecycle policies** automatically transition logs:
  - Standard → IA (30 days)
  - IA → Glacier (60 days)
  - Delete (90 days)
- **CloudWatch logs retention** (14 days default)
- **Minimal CloudWatch** usage for cost control

## Compliance Notes

- **SOC2**: ✅ Audit logging requirement
- **HIPAA**: ✅ Access monitoring requirement
- **PCI-DSS**: ✅ Log monitoring requirement
- **ISO 27001**: ✅ Information security monitoring

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `app_name` | Application name | `string` | `"the-awesome-app"` |
| `environment` | Environment name | `string` | `"development"` |
| `enable_cloudwatch_logs` | Enable CloudWatch integration | `bool` | `true` |
| `log_retention_days` | S3 log retention | `number` | `90` |
| `include_global_service_events` | Include global services | `bool` | `true` |
| `is_multi_region_trail` | Multi-region trail | `bool` | `true` |

## Dependencies

- AWS provider ~> 4.16
- Random provider ~> 3.1
- S3 backend for state storage

## Integration

This module works with:
- ✅ **All existing infrastructure** (zero disruption)
- ✅ **Service users** (they'll be audited)
- ✅ **Lambda functions** (their executions logged)
- ✅ **RDS/DynamoDB** (management events logged)
- ✅ **Future KMS module** (can provide encryption key)

## Troubleshooting

**CloudTrail not logging:**
```bash
aws cloudtrail get-trail-status --name the-awesome-app-cloudtrail
```

**S3 permissions issues:**
```bash
aws s3api get-bucket-policy --bucket $(terraform output -raw s3_bucket_name)
```

**Missing events:**
- Check if multi-region is enabled for global services
- Verify event selectors for data events
- CloudWatch delivery can take 5-15 minutes 