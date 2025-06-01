# Outputs for the Cognito User Pool and related resources
output "user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.app_user_pool.id
}

output "client_id" {
  description = "The Client ID for the Cognito User Pool App Client"
  value       = aws_cognito_user_pool_client.frontend.id
}

output "user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.app_user_pool.arn
}

output "identity_provider_name" {
  description = "The provider name of the Cognito User Pool"
  value       = "cognito-idp.${data.aws_region.current.name}.amazonaws.com/${aws_cognito_user_pool.app_user_pool.id}"
}

output "frontend_client_id" {
  description = "The Client ID for the frontend Cognito User Pool App Client"
  value       = aws_cognito_user_pool_client.frontend.id
}

output "user_pool_endpoint" {
  description = "The endpoint URL for the Cognito User Pool"
  value       = aws_cognito_user_pool.app_user_pool.endpoint
}

output "user_pool_domain" {
  description = "The domain name of the Cognito User Pool"
  value       = aws_cognito_user_pool_domain.main.domain
}

output "user_pool_region" {
  description = "The AWS region where the Cognito User Pool is deployed"
  value       = data.aws_region.current.name
} 