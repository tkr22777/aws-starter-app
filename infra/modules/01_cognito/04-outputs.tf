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

# Additional outputs for easier application integration
output "hosted_ui_url" {
  description = "The complete URL for Cognito's hosted authentication UI"
  value       = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${data.aws_region.current.name}.amazoncognito.com"
}

output "app_configuration" {
  description = "Complete configuration object for frontend integration"
  value = {
    region              = data.aws_region.current.name
    userPoolId         = aws_cognito_user_pool.app_user_pool.id
    userPoolWebClientId = aws_cognito_user_pool_client.frontend.id
    domain             = "${aws_cognito_user_pool_domain.main.domain}.auth.${data.aws_region.current.name}.amazoncognito.com"
    redirectSignIn     = var.app_callback_urls[0]
    redirectSignOut    = var.app_logout_urls[0]
  }
} 