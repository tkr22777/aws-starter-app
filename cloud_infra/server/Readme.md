# Current features: 
- Setting up terraform and AWS region (00-main.tf)
- Setting up VPC, Internet Gateway, Route Table (01-vpc.tf)
- Setting up Subnet and Subnet-Route Table association (02-subnet.tf)
- Setting up Security Group to configure ingress/egress (03-security.tf)
- Setting up EC2 instance, ElasticIP for the instance and associating the SG with EC2 (04-nodes.tf)

# Steps
- 1. Install aws-cli
- 2. Configure AWS secrets: `aws configure`
- 3. Run `terraform apply`
- 4. Currently the EC2 instance a test_key private key. A corresponding public key is required to ssh to the instance. The domain name for the ec2 instance can be found at terraform.tfstate artifact. Command: `ssh ec2-user@hostname -i test_key.pem`
- 5. Copy server files to `scp -i test_key.pem -r ../../api ec2-user@hostname:~`
- 6. Setup app servers on the ec2 instance manually using docker

# To do:
- 1. create terraform output (currently manually scanned from the tfstate file)
- 2. automate the server deployment to the node
- 3. the test_key is created manually using AWS console UI, autoamte that
- 4. get reviewed for security