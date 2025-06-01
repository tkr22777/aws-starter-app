output "user_pool_id" {
  description = "The ID of the Cognito User Pool in production."
  value       = module.cognito.user_pool_id
}

output "client_id" {
  description = "The Client ID for the Cognito User Pool App Client in production."
  value       = module.cognito.client_id
}

output "user_pool_arn" {
  description = "The ARN of the Cognito User Pool in production."
  value       = module.cognito.user_pool_arn
}

output "identity_provider_name" {
  description = "The provider name of the Cognito User Pool in production."
  value       = module.cognito.identity_provider_name
}

output "frontend_client_id" {
  description = "The Client ID for the frontend Cognito User Pool App Client in production."
  value       = module.cognito.frontend_client_id
}

output "user_pool_endpoint" {
  description = "The endpoint URL for the Cognito User Pool in production."
  value       = module.cognito.user_pool_endpoint
}

output "user_pool_domain" {
  description = "The domain name of the Cognito User Pool in production."
  value       = module.cognito.user_pool_domain
}

output "user_pool_region" {
  description = "The AWS region where the Cognito User Pool is deployed for production."
  value       = module.cognito.user_pool_region
} 