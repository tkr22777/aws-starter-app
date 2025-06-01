# Get EC2 module state for security group ID
data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = "terraform-state-store-24680"
    key    = "environments/prod/04_ec2/terraform.tfstate"
    region = "us-east-1"
  }
}

# Get RDS module state for security group ID  
data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = "terraform-state-store-24680"
    key    = "environments/prod/03_rds/terraform.tfstate"
    region = "us-east-1"
  }
} 