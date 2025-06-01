# Remote state data source to get network module outputs
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-state-store-24680"
    key    = "environments/prod/02_network/terraform.tfstate"
    region = "us-east-1"
  }
}

# Local values to use network outputs or fallback to variables
locals {
  vpc_id = var.vpc_id != "" ? var.vpc_id : data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = length(var.subnet_ids) > 0 ? var.subnet_ids : [
    data.terraform_remote_state.network.outputs.subnet_id,
    data.terraform_remote_state.network.outputs.subnet_ha_2_id
  ]
} 