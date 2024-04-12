# Current features: 
- Setting up terraform and AWS region (00-main.tf)
- Setting up user-pool and user-pool-client (01-user-pool.tf)


# Steps
- 1. Install aws-cli
- 2. Configure AWS secrets: `aws configure`
- 3. Run `terraform apply`
- 4. The user pool and user pool client can be found at terraform.tfstate artifact, use them on your frontend and backend.

# To do:
- 1. create terraform output (currently manually scanned from the tfstate file)