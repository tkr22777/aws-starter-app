# DynamoDB Single-Table Module

This module provisions a DynamoDB table configured for a single-table design pattern.

## Single-Table Design

This table follows the single-table design pattern for NoSQL databases, where multiple entity types are stored in the same table using a carefully designed primary key structure. This approach improves performance and reduces costs by minimizing the number of tables needed.

## Key Structure

The table uses:
- Partition Key (PK): String identifier containing entity type prefix (e.g., `USER#123`, `ORDER#456`)
- Sort Key (SK): String identifier for the item type and relationships (e.g., `PROFILE`, `ORDER#789`, `METADATA`)

## Resources Created

- **DynamoDB Table**: Single table with composite primary key (PK + SK)
- **Global Secondary Index**: Inverted index for SK → PK lookups
- **Time-to-Live (TTL)**: Configuration for automatic item expiration
- **Point-in-Time Recovery**: Continuous backups (enabled by default)
- **Server-Side Encryption**: AWS-managed encryption by default

## Usage

```hcl
module "dynamodb" {
  source = "../08_commons/mono-ddb-table"
  
  app_name  = "your-app-name"
  table_name = "mono-table"
  
  # Optional configuration
  billing_mode = "PAY_PER_REQUEST"  # or "PROVISIONED"
  hash_key = "PK"
  range_key = "SK"
  
  # If using PROVISIONED billing mode
  read_capacity = 5
  write_capacity = 5
  
  # Recovery and encryption
  enable_point_in_time_recovery = true
  enable_encryption = true
}
```

## Access Patterns

The single-table design supports these common access patterns:

| Access Pattern | Key Condition | Index |
|----------------|---------------|-------|
| Get item by ID | PK = "ENTITY#id" AND SK = "METADATA" | Primary |
| Get all items of specific type | PK begins_with "TYPE#" | Primary |
| Find relationships | PK = "ENTITY#id" AND SK begins_with "REL#" | Primary |
| Reverse lookup | SK = "TYPE" AND PK begins_with "ENTITY#" | GSI1 |

## Item Structure Examples

### User Profile
```json
{
  "PK": "USER#123",
  "SK": "PROFILE",
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2023-01-01T12:00:00Z"
}
```

### Order
```json
{
  "PK": "ORDER#456",
  "SK": "METADATA",
  "user_id": "USER#123",
  "order_date": "2023-02-15T09:30:00Z",
  "total": 99.99,
  "status": "SHIPPED"
}
```

### User-Order Relationship
```json
{
  "PK": "USER#123",
  "SK": "ORDER#456",
  "order_date": "2023-02-15T09:30:00Z"
}
``` 