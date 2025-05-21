output "table_name" {
  description = "The name of the DynamoDB table"
  value       = aws_dynamodb_table.mono_table.name
}

output "table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = aws_dynamodb_table.mono_table.arn
}

output "table_id" {
  description = "The ID of the DynamoDB table"
  value       = aws_dynamodb_table.mono_table.id
}

output "table_hash_key" {
  description = "The hash key (partition key) of the DynamoDB table"
  value       = aws_dynamodb_table.mono_table.hash_key
}

output "table_range_key" {
  description = "The range key (sort key) of the DynamoDB table"
  value       = aws_dynamodb_table.mono_table.range_key
}

output "gsi_name" {
  description = "The name of the global secondary index"
  value       = "GSI1"
} 