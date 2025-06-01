# Cognito User Pool Configuration

## Overview
This Terraform configuration sets up AWS Cognito User Pool for authentication.

## Resources Created

- **Cognito User Pool** (`aws_cognito_user_pool.app_user_pool`)
  - Function: Core user directory service for managing user accounts, authentication, and profiles.
  - Features: Email-based login, custom attributes (e.g., `role`), password policies, and MFA (currently OFF).

- **User Pool Client** (`aws_cognito_user_pool_client.frontend`)
  - Function: Defines an application client that can interact with the User Pool.
  - Relation: Connects to `app_user_pool` to allow frontend applications to perform authentication (e.g., sign-up, sign-in).
  - Configuration: No client secret generated, specific authentication flows enabled.

- **User Pool Domain** (`aws_cognito_user_pool_domain.main`)
  - Function: Provides a unique, customizable domain for Cognito's hosted UI and service endpoints.
  - Relation: Associated with `app_user_pool` to provide a stable URL for authentication operations.
  - Example: `your-app-name-auth.auth.your-region.amazoncognito.com`.

## Prerequisites
1. AWS CLI installed
2. Terraform installed
3. AWS credentials configured for terraform user
