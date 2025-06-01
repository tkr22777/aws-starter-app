# =============================================================================
# Remote State Data Sources
# =============================================================================

# Reference network module remote state
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-state-store-24680"
    key    = "environments/prod/02_network/terraform.tfstate"
    region = var.aws_region
  }
} 