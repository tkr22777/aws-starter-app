# Network module remote state
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-state-store-24680"
    key    = "environments/prod/02_network/terraform.tfstate"
    region = "us-east-1"
  }
}

# EC2 module remote state
data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = "terraform-state-store-24680"
    key    = "environments/prod/04_ec2/terraform.tfstate"
    region = "us-east-1"
  }
}

# ALB module remote state (conditional - may not exist yet)
# data "terraform_remote_state" "alb" {
#   backend = "s3"
#   config = {
#     bucket = "terraform-state-store-24680"
#     key    = "environments/prod/02a_alb/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

# Local values for resource IDs
locals {
  # Network configuration from network module
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  # EC2 configuration from EC2 module
  ec2_instance_id = data.terraform_remote_state.ec2.outputs.instance_id

  # ALB configuration (empty for now since ALB doesn't exist yet)
  # When ALB is deployed, we can uncomment the data source above and use:
  # alb_listener_arn = data.terraform_remote_state.alb.outputs.listener_arn
  alb_listener_arn = ""
} 