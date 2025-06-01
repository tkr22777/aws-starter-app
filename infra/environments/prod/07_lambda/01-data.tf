# =============================================================================
# Remote State Data Sources
# =============================================================================

# Get SQS information from remote state
data "terraform_remote_state" "sqs" {
  backend = "s3"
  config = {
    bucket = "terraform-state-store-24680"
    key    = "environments/prod/06_sqs/terraform.tfstate"
    region = "us-east-1"
  }
} 