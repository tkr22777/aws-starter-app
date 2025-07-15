data "aws_region" "current" {}

resource "aws_cognito_user_pool" "app_user_pool" {
  name = "${var.app_name}-${var.environment}-user-pool"
  deletion_protection = "INACTIVE" # INACTIVE allows pool deletion, ACTIVE prevents accidental deletion

  username_attributes = ["email"] # Users sign in with email instead of username

  username_configuration {
    case_sensitive = var.case_sensitive_usernames # When false, "User@example.com" = "user@example.com"
  }

  auto_verified_attributes = var.auto_verify_email ? ["email"] : [] # Automatically mark email as verified upon confirmation

  mfa_configuration = var.enable_mfa # Options: OFF, ON (required), OPTIONAL

  password_policy {
    minimum_length    = var.password_minimum_length
    require_lowercase = true
    require_numbers   = true
    require_symbols   = var.require_password_symbols
    require_uppercase = true
  }

  /** Required Standard Attributes*/
  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = false # Email cannot be changed after user creation - prevents account takeover

    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }

  /** Custom Attributes */
  dynamic "schema" {
    for_each = var.enable_custom_role_attribute ? [1] : []
    content {
      attribute_data_type      = "String"
      name                     = "role"
      required                 = false
      mutable                  = true
      developer_only_attribute = false # True = only backend can read/write, False = frontend can access

      string_attribute_constraints {
        min_length = 1
        max_length = 2048
      }
    }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE" # Send 6-digit code vs CONFIRM_WITH_LINK for clickable link
    email_subject       = "Your verification code"
    email_message       = "Your verification code is {####}" # {####} placeholder for the verification code
  }
}

resource "aws_cognito_user_pool_client" "frontend" {
  name = "${var.app_name}-${var.environment}-cognito-frontend"

  user_pool_id = aws_cognito_user_pool.app_user_pool.id

  generate_secret     = false # Frontend apps can't securely store secrets (public clients)

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",      # Secure Remote Password - passwordless authentication flow
    "ALLOW_REFRESH_TOKEN_AUTH"  # Allows using refresh tokens to get new access tokens
  ]
  
  callback_urls        = var.app_callback_urls
  logout_urls          = var.app_logout_urls
  allowed_oauth_flows_user_pool_client = true # Required to enable OAuth flows
  allowed_oauth_flows  = ["code", "implicit"] # Authorization code flow (secure) and implicit flow (legacy)
  allowed_oauth_scopes = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"] # Last scope allows user to call Cognito APIs
  supported_identity_providers = ["COGNITO"] # Could also include "Google", "Facebook", SAML providers
}

/*
resource "aws_cognito_user_pool_client" "backend" {
  name = "backend"

  user_pool_id = aws_cognito_user_pool.blank_app_users.id

  generate_secret     = true

  // TO DO: change to more flows
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ] 
}
*/

# Domain for user pool - added to fix missing resource reference
resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.app_name}-${var.environment}-auth" # Creates hosted UI at https://{domain}.auth.{region}.amazoncognito.com
  user_pool_id = aws_cognito_user_pool.app_user_pool.id
}
