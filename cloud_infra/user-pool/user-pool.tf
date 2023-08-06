resource "aws_cognito_user_pool" "white_app_users" {

  name = "white_app_users"

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
    require_symbols   = true
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

  user_pool_id = aws_cognito_user_pool.white_app_users.id

  generate_secret     = false

  // TO DO: change to more flows
  explicit_auth_flows = [
    //"ALLOW_ADMIN_USER_PASSWORD_AUTH",
    //"ALLOW_USER_SRP_AUTH",
    //"ALLOW_REFRESH_TOKEN_AUTH",
    "ADMIN_NO_SRP_AUTH"
  ] 
}

/*
resource "aws_cognito_user_pool_client" "backend" {
  name = "backend"

  user_pool_id = aws_cognito_user_pool.white_app_users.id

  generate_secret     = true

  // TO DO: change to more flows
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ] 
}
*/