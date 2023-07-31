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
    name                     = "Role"
    required                 = false
    mutable                  = true
    developer_only_attribute = true

    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "client"

  user_pool_id = aws_cognito_user_pool.white_app_users.id

  generate_secret     = false

  // TO DO: change to more flows
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"] 
}