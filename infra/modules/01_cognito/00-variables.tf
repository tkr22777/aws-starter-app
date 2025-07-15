# =============================================================================
# Application Configuration
# =============================================================================

variable "app_name" {
  type        = string
  description = "Base name of the application, used for resource naming and tagging."
  default     = "the-awesome-app"
}

variable "environment" {
  description = "Environment name (e.g., prod, dev, staging). Used for resource tagging and isolation."
  type        = string
  default     = "prod"
}

# =============================================================================
# Authentication Flow Configuration
# =============================================================================

variable "app_callback_urls" {
  description = "List of allowed callback URLs where users are redirected after successful authentication. Use localhost for development, production domains for live apps."
  type        = list(string)
  default     = ["http://localhost:3000/callback"] # Development default - replace with production URLs
  
  validation {
    condition = length(var.app_callback_urls) > 0
    error_message = "At least one callback URL must be provided for authentication flow."
  }
}

variable "app_logout_urls" {
  description = "List of allowed logout URLs where users are redirected after signing out. Should match your app's logout handling endpoints."
  type        = list(string)
  default     = ["http://localhost:3000/logout"] # Development default - replace with production URLs
  
  validation {
    condition = length(var.app_logout_urls) > 0
    error_message = "At least one logout URL must be provided for authentication flow."
  }
}

# =============================================================================
# User Pool Security Configuration
# =============================================================================

variable "enable_mfa" {
  description = "Enable Multi-Factor Authentication. OFF = no MFA, OPTIONAL = user choice, ON = required for all users. Recommended for production."
  type        = string
  default     = "OFF"
  
  validation {
    condition = contains(["OFF", "ON", "OPTIONAL"], var.enable_mfa)
    error_message = "MFA configuration must be OFF, ON, or OPTIONAL."
  }
}

variable "password_minimum_length" {
  description = "Minimum password length for user accounts. Balances security with user experience."
  type        = number
  default     = 8
  
  validation {
    condition = var.password_minimum_length >= 6 && var.password_minimum_length <= 99
    error_message = "Password minimum length must be between 6 and 99 characters."
  }
}

variable "require_password_symbols" {
  description = "Require special characters in passwords. Increases security but may impact user experience."
  type        = bool
  default     = false
}

# =============================================================================
# User Registration Configuration
# =============================================================================

variable "auto_verify_email" {
  description = "Automatically verify email addresses during registration. Recommended for most applications."
  type        = bool
  default     = true
}

variable "case_sensitive_usernames" {
  description = "Make usernames case sensitive. FALSE recommended to prevent user confusion (user@example.com = User@example.com)."
  type        = bool
  default     = false
}

# =============================================================================
# Custom User Attributes
# =============================================================================

variable "enable_custom_role_attribute" {
  description = "Add a custom 'role' attribute for user authorization (e.g., admin, user, moderator). Useful for role-based access control."
  type        = bool
  default     = true
}