# Current features: 
- Setting up terraform and AWS region (00-main.tf)
- Setting up VPC, Internet Gateway, Route Table (01-vpc.tf)
- Setting up Subnet and Subnet-Route Table association (02-subnet.tf)
- Setting up Security Group to configure ingress/egress (03-security.tf)
- Setting up EC2 instance, ElasticIP for the instance and associating the SG with EC2 (04-nodes.tf)

# Steps
- 1. Install aws-cli
- 2. Configure AWS secrets: `aws configure`
- 3. Run: `terraform apply -auto-approve`
- 4. Check hostname: `terraform output -json > output.json`
- 5. Copy service code: `scp -i test_key.pem -r ../../api ec2-user@hostname:~`
- 6. Login: `ssh -i test_key.pem ec2-user@hostname; cd api`
- 7. Build docker image: `docker build --no-cache=true -t user_setting_app .`
- 8. Run the image: `docker run -p 80:8000 --name user_setting_app_instance -i -t -d user_setting_app`
- 9. DB login: `psql -h db-endpoint -p 5432 -U postgres -d postgres`


# To do:
- 1. automate the server deployment to the node
- 2. the test_key is created manually using AWS console UI, autoamte that
- 3. get reviewed for security