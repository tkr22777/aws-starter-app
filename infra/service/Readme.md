# Current features: 
- Setting up terraform and AWS region (00-main.tf)
- Setting up VPC, Internet Gateway, Route Table (01-vpc.tf)
- Setting up Subnet and Subnet-Route Table association (02-subnet.tf)
- Setting up App EC2 instance and its corresponding Security Group (03-nodes.tf)
- Setting up RDS instance, its Subnet and Security Group  (04-db.tf)
- Setting up ECR for the apps service
- Setting up ECS cluster

# Steps
- 1. Install aws-cli
- 2. Configure AWS secrets: `aws configure`
- 3. (a) Run: `terraform import aws_iam_user.terraform_user terraform_user`
- 3. (b) Run: `terraform apply -auto-approve`
- 4. Check hostname: `terraform output -json > output.json`
- 5. Copy service code: `scp -i test_key.pem -r ../../api ec2-user@hostname:~`
- 6. Login: `ssh -i test_key.pem ec2-user@hostname; cd api`
- 7. Build docker image: `docker build --no-cache=true -t starter_app .`
- 8. Run the image: `docker run -p 80:8000 --name starter_app_instance -i -t -d starter_app`
- 9. DB login: `psql -h db-endpoint -p 5432 -U postgres -d postgres`


# Using ECR:
* connect docker with aws ecr:
`aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 894135990422.dkr.ecr.us-east-2.amazonaws.com`

* other commands:
```
aws ecr describe-repositories
aws ecr list-images
docker pull 894135990422.dkr.ecr.us-east-2.amazonaws.com/your-repo-name:your-image-tag
```

# To do:
- 1. the test_key is created manually using AWS console UI, autoamte that
- 2. review security