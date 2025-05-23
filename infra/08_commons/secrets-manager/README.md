# Secrets Manager Module

Secure storage for database credentials, API keys, and other sensitive data with automatic encryption and rotation.

## Configuration

```hcl
# terraform.tfvars
secrets = {
  "database-password" = {
    description          = "RDS master password"
    generate_password    = true
    password_length      = 20
    recovery_window_days = 7
  }
  "api-key" = {
    description          = "Third-party API key"
    secret_string        = "your-api-key-here"
    recovery_window_days = 30
  }
}
```

## Usage

### Retrieve Secrets
```bash
# Get secret value
aws secretsmanager get-secret-value --secret-id my-app-database-password --query SecretString --output text --profile terraform_user

# List all secrets
aws secretsmanager list-secrets --filter Key=name,Values=my-app --profile terraform_user
```

### Update Secrets
```bash
# Update secret
aws secretsmanager update-secret --secret-id my-app-api-key --secret-string "new-value" --profile terraform_user

# Update JSON secret
aws secretsmanager update-secret --secret-id my-app-database-config --secret-string '{"username":"admin","password":"newpass"}' --profile terraform_user
```

### Application Integration
```python
# Python boto3
import boto3
import json

client = boto3.client('secretsmanager')

def get_secret(secret_name):
    response = client.get_secret_value(SecretId=secret_name)
    return response['SecretString']

# Get database credentials
db_password = get_secret('my-app-database-password')

# Get JSON secret
config_json = get_secret('my-app-config')
config = json.loads(config_json)
```

### Environment Variables
```bash
# Export secret as environment variable
export DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id my-app-database-password --query SecretString --output text --profile terraform_user)

# Use in application
echo "Database password: $DB_PASSWORD"
```

## Security Features

- **KMS Encryption**: Customer-managed encryption keys
- **Access Control**: IAM-based permissions
- **Audit Logging**: CloudTrail integration
- **Version Management**: Automatic versioning
- **Cross-Region Replication**: High availability 