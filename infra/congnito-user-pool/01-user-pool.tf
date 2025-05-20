resource "aws_cognito_user_pool" "starter_app_users" {

  name = "starter_app_users"

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
}

resource "aws_cognito_user_pool_client" "frontend" {
  name = "frontend"

  user_pool_id = aws_cognito_user_pool.starter_app_users.id

  generate_secret     = false

  // TO DO: change to more flows
  explicit_auth_flows = [
    //"ALLOW_ADMIN_USER_PASSWORD_AUTH", // Allows admin authentication using username and password
    //"ALLOW_USER_SRP_AUTH", // Allows user authentication using Secure Remote Password protocol
    //"ALLOW_REFRESH_TOKEN_AUTH", // Allows refresh token authentication, enabling longer-lived sessions
    "ADMIN_NO_SRP_AUTH" // Allows admin authentication without Secure Remote Password protocol, enabling simpler but less secure admin authentication flows
  ] 
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