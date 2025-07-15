# Cognito User Pool Module

AWS Cognito User Pool for application authentication and user management.

## 🔐 **Authentication Architecture**

**User Pool**: Central user directory managing registration, login, and profiles
**App Client**: Connects your frontend application to the user pool
**Hosted Domain**: Provides authentication URLs for sign-in/sign-up flows

## 🎯 **Application Integration**

### **Frontend Integration**
- **React/Vue/Angular**: Use AWS Amplify SDK or Cognito SDK
- **Mobile Apps**: AWS Mobile SDK with Cognito support
- **Server-Side**: Validate JWT tokens from Cognito

### **Authentication Flow**
1. User clicks "Sign In" in your app
2. Redirect to Cognito hosted UI (`your-app-auth.auth.region.amazoncognito.com`)
3. User authenticates with email/password
4. Cognito redirects to your `app_callback_urls` with JWT token
5. Your app validates token and grants access

## 📋 **Configuration for Different App Types**

### **Local Development**
```hcl
app_callback_urls = ["http://localhost:3000/callback"]
app_logout_urls   = ["http://localhost:3000/logout"]
enable_mfa        = "OFF"
```

### **Production Web App**
```hcl
app_callback_urls = [
  "https://yourapp.com/auth/callback",
  "https://app.yourapp.com/callback"
]
app_logout_urls = [
  "https://yourapp.com/auth/logout",
  "https://app.yourapp.com/logout"
]
enable_mfa = "OPTIONAL"  # Let users choose
```

### **High Security App**
```hcl
enable_mfa                = "ON"      # Force MFA for all users
password_minimum_length   = 12       # Strong passwords
require_password_symbols  = true     # Special characters required
```

## 🔧 **Variable Configuration Guide**

### **Authentication URLs**
- **`app_callback_urls`**: Where users land after successful login
  - Development: `http://localhost:3000/callback`
  - Production: `https://yourapp.com/auth/callback`
  - Multiple environments: Add all URLs you need

- **`app_logout_urls`**: Where users go after signing out
  - Should handle clearing local session/tokens
  - Often your app's landing page or login screen

### **Security Settings**
- **`enable_mfa`**: 
  - `"OFF"`: Development/testing (faster)
  - `"OPTIONAL"`: Production (user choice)
  - `"ON"`: High security (required)

- **`password_minimum_length`**: Balance security vs. usability
  - 8: Standard for most apps
  - 12+: High security requirements

### **User Experience**
- **`auto_verify_email`**: `true` = seamless registration
- **`case_sensitive_usernames`**: `false` = prevents user confusion
- **`enable_custom_role_attribute`**: `true` = enables role-based access

## 🏗️ **Resources Created**

### **User Pool** (`aws_cognito_user_pool.app_user_pool`)
- **Purpose**: Core user directory and authentication service
- **Features**: Email login, password policies, custom attributes
- **Integration**: Your app validates JWT tokens from this pool

### **App Client** (`aws_cognito_user_pool_client.frontend`)
- **Purpose**: Authorizes your frontend to use the user pool
- **Configuration**: No client secret (suitable for SPAs), OAuth flows enabled
- **Usage**: Configure in your app's authentication library

### **Hosted Domain** (`aws_cognito_user_pool_domain.main`)
- **Purpose**: Provides stable URLs for authentication UI
- **Format**: `{app_name}-auth.auth.{region}.amazoncognito.com`
- **Usage**: Redirect users here for login/signup

## 📱 **Integration Examples**

### **React with AWS Amplify**
```javascript
import { Amplify } from 'aws-amplify';

Amplify.configure({
  Auth: {
    region: 'us-east-1',
    userPoolId: 'us-east-1_xxxxxxxxx',        // From terraform output
    userPoolWebClientId: 'xxxxxxxxxxxxxxxxxx', // From terraform output
    oauth: {
      domain: 'your-app-auth.auth.us-east-1.amazoncognito.com',
      redirectSignIn: 'http://localhost:3000/callback',
      redirectSignOut: 'http://localhost:3000/logout',
      responseType: 'code'
    }
  }
});
```

### **JWT Token Validation (Backend)**
```python
import jwt
from cognitojwt import CognitoJWTVerifier

verifier = CognitoJWTVerifier(
    region='us-east-1',
    userpool_id='us-east-1_xxxxxxxxx',
    app_client_id='xxxxxxxxxxxxxxxxxx'
)

# Validate token from frontend
token_valid = verifier.verify(jwt_token)
```

## 🚀 **Deployment**

```bash
cd infra/01_cognito
terraform init
terraform plan
terraform apply  # ~1-2 minutes
```

## 📋 **Post-Deployment**

1. **Get outputs**: `terraform output` for user pool ID and client ID
2. **Configure app**: Update frontend authentication configuration
3. **Test flow**: Try registration/login with test user
4. **Update URLs**: Replace localhost URLs with production domains

## 🔗 **Dependencies**

- **Deploy first**: No dependencies on other modules
- **Used by**: Frontend applications, API authentication middleware
- **Integration**: Works with ALB for authenticated endpoints
