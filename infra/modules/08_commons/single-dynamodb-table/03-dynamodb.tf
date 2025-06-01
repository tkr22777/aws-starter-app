resource "aws_dynamodb_table" "mono_table" {
  name         = "${var.app_name}-${var.table_name}"
  billing_mode = var.billing_mode
  
  # Only set these if using PROVISIONED billing mode
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  
  # Key schema (primary key)
  hash_key  = var.hash_key
  range_key = var.range_key
  
  # Attribute definitions required for keys
  attribute {
    name = var.hash_key
    type = "S"
  }
  
  attribute {
    name = var.range_key
    type = "S"
  }
  
  # Create a GSI for reverse lookup (SK → PK)
  global_secondary_index {
    name               = "GSI1"
    hash_key           = var.range_key
    range_key          = var.hash_key
    projection_type    = "ALL"
    # Only set these if using PROVISIONED billing mode
    read_capacity      = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
    write_capacity     = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  }
  
  # Optional Time-to-Live configuration
  ttl {
    enabled        = true
    attribute_name = var.ttl_attribute
  }
  
  # Point-in-time recovery
  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }
  
  # Server-side encryption
  server_side_encryption {
    enabled = var.enable_encryption
  }
  
  # Additional customizations for a single-table design
  tags = {
    Name        = "${var.app_name}-${var.table_name}"
    Description = "Single-table design DynamoDB table for ${var.app_name}"
  }
} 