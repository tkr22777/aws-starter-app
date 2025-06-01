# =============================================================================
# ALB Module Configuration
# =============================================================================

module "alb" {
  source = "../../../modules/02a_alb"

  # Application configuration
  app_name    = var.app_name
  environment = var.environment

  # Network configuration from remote state
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = [
    data.terraform_remote_state.network.outputs.subnet_id,
    data.terraform_remote_state.network.outputs.subnet_ha_2_id
  ]

  # ALB configuration
  enable_deletion_protection = var.enable_deletion_protection
  internal                   = var.internal

  # Health check configuration (using module defaults)
  health_check_enabled  = true
  health_check_path     = "/"
  health_check_interval = 30
  health_check_timeout  = 5
  healthy_threshold     = 2
  unhealthy_threshold   = 2
  health_check_matcher  = "200,404"
} 