# DynamoDB Single-Table Module

NoSQL database using single-table design pattern for optimal performance and cost efficiency.

## Configuration

```hcl
# terraform.tfvars
table_name = "my-app-main-table"
billing_mode = "PAY_PER_REQUEST"    # or "PROVISIONED" 
enable_point_in_time_recovery = true
enable_encryption = true
```

## Key Structure

- **Partition Key (PK)**: Entity type + ID (e.g., `USER#123`, `ORDER#456`)
- **Sort Key (SK)**: Item type or relationship (e.g., `PROFILE`, `ORDER#789`)
- **GSI1**: Inverted index for reverse lookups (SK → PK)

## Usage

### Put/Get Items
```bash
# Put user profile
aws dynamodb put-item --table-name my-app-main-table --item '{"PK":{"S":"USER#123"},"SK":{"S":"PROFILE"},"name":{"S":"John"},"email":{"S":"john@example.com"}}' --profile dynamodb-svc

# Get user profile
aws dynamodb get-item --table-name my-app-main-table --key '{"PK":{"S":"USER#123"},"SK":{"S":"PROFILE"}}' --profile dynamodb-svc

# Query all user items
aws dynamodb query --table-name my-app-main-table --key-condition-expression 'PK = :pk' --expression-attribute-values '{":pk":{"S":"USER#123"}}' --profile dynamodb-svc
```

### Application Integration
```python
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('my-app-main-table')

# Put item
table.put_item(Item={
    'PK': 'USER#123',
    'SK': 'PROFILE',
    'name': 'John Doe',
    'email': 'john@example.com'
})

# Get item
response = table.get_item(Key={'PK': 'USER#123', 'SK': 'PROFILE'})
user = response.get('Item')

# Query pattern
response = table.query(KeyConditionExpression=Key('PK').eq('USER#123'))
user_items = response['Items']
```

## Data Patterns

### User Profile
```json
{
  "PK": "USER#123",
  "SK": "PROFILE", 
  "name": "John Doe",
  "email": "john@example.com"
}
```

### Order + User Relationship
```json
{
  "PK": "ORDER#456",
  "SK": "METADATA",
  "user_id": "USER#123",
  "total": 99.99
},
{
  "PK": "USER#123", 
  "SK": "ORDER#456",
  "order_date": "2023-02-15"
}
```

## Cost Optimization

- **On-Demand**: Pay per request (good for unpredictable traffic)
- **Provisioned**: Fixed capacity (20-40% cheaper for steady traffic)  
- **Auto-scaling**: Adjust capacity based on usage
- **TTL**: Automatic item expiration to reduce storage costs 