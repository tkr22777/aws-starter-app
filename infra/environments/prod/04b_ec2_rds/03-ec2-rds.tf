module "ec2_rds" {
  source = "../../../modules/04b_ec2_rds"
  
  app_name    = var.app_name
  environment = var.environment
  
  # Use remote state values for security group IDs
  ec2_security_group_id = data.terraform_remote_state.ec2.outputs.security_group_id
  rds_security_group_id = data.terraform_remote_state.rds.outputs.rds_security_group_id
} 