data "aws_region" "current" {}

resource "aws_cognito_user_pool" "app_user_pool" {
  name = "${var.app_name}-user-pool"
  deletion_protection = "INACTIVE"

  username_attributes = ["email"]

  username_configuration {
    case_sensitive = false
  }

  auto_verified_attributes = ["email"]

  mfa_configuration = "OFF"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  /** Required Standard Attributes*/
  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = false

    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }

  /** Custom Attributes */
  schema {
    attribute_data_type      = "String"
    name                     = "role"
    required                 = false
    mutable                  = true
    developer_only_attribute = false

    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject       = "Your verification code"
    email_message       = "Your verification code is {####}"
  }
}

resource "aws_cognito_user_pool_client" "frontend" {
  name = "${var.app_name}-cognito-frontend"

  user_pool_id = aws_cognito_user_pool.app_user_pool.id

  generate_secret     = false

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
  
  callback_urls        = var.app_callback_urls
  logout_urls          = var.app_logout_urls
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows  = ["code", "implicit"]
  allowed_oauth_scopes = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  supported_identity_providers = ["COGNITO"]
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
  domain       = "${var.app_name}-auth"
  user_pool_id = aws_cognito_user_pool.app_user_pool.id
}
