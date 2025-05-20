# EC2 Key Pair Management

## Key Pair Creation
Terraform will automatically generate an SSH key pair:
- A private key will be saved as ~/.ssh/<instance-name>-key.pem
- The public key will be uploaded to AWS and associated with the EC2 instance
- Outputs will include the ssh command to connect to the instance

## Instance Initialization
The user_data script is not executing for some reason.
For test deployment, the script should be executed after instance creation.
