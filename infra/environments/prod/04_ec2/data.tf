# Network module remote state
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-state-store-24680"
    key    = "environments/prod/02_network/terraform.tfstate"
    region = "us-east-1"
  }
}

# Local values for resource IDs
locals {
  # Network configuration from network module
  vpc_id    = data.terraform_remote_state.network.outputs.vpc_id
  subnet_id = data.terraform_remote_state.network.outputs.subnet_id
} 