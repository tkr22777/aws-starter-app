# CloudWatch Logs Module

Centralized application logging with 8 pre-configured log groups, metric filters, and retention policies.

## Configuration

Customize log retention in `terraform.tfvars`:

```hcl
log_groups = {
  app         = { retention_days = 30 }  # Application logs
  api         = { retention_days = 30 }  # API requests/responses  
  web         = { retention_days = 14 }  # Web server access logs
  worker      = { retention_days = 30 }  # Background jobs
  database    = { retention_days = 7 }   # DB slow queries
  security    = { retention_days = 90 }  # Auth failures
  performance = { retention_days = 7 }   # Metrics
  audit       = { retention_days = 365 } # Compliance
}
```

## Usage

### Tail Logs
```bash
# Real-time application logs
aws logs tail /aws/my-app/app --follow --profile terraform_user

# Filter for errors only
aws logs filter-log-events --log-group-name /aws/my-app/app --filter-pattern ERROR --profile terraform_user
```

### Application Integration
```python
# Python logging
import boto3
import json
import logging

client = boto3.client('logs')
handler = logging.StreamHandler()
logger = logging.getLogger()
logger.addHandler(handler)

# Log to CloudWatch
logger.info(json.dumps({"event": "user_login", "user_id": "123"}))
```

### Docker Integration
```dockerfile
# Use AWS CloudWatch log driver
docker run --log-driver=awslogs \
  --log-opt awslogs-group=/aws/my-app/app \
  --log-opt awslogs-region=us-east-1 \
  my-app:latest
```

## Cost Optimization

- Database logs: 7 days retention (~$0.50/GB/month)
- Application logs: 30 days retention (~$1.50/GB/month)  
- Audit logs: 365 days retention (~$18/GB/month)
- Use metric filters instead of storing verbose logs 