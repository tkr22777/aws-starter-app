# Random password generation for secrets that require it
resource "random_password" "generated_secrets" {
  for_each = {
    for name, config in var.secrets : name => config
    if config.generate_password == true
  }
  
  length  = each.value.password_length
  special = each.value.include_special
  
  # Exclude problematic characters
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# AWS Secrets Manager secrets
resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secrets
  
  name        = "${var.app_name}-${each.key}"
  description = each.value.description
  
  # KMS encryption
  kms_key_id = var.kms_key_id
  
  # Recovery window
  recovery_window_in_days = each.value.recovery_window_days
  
  # Replication configuration
  dynamic "replica" {
    for_each = var.replica_regions
    content {
      region     = replica.value.region
      kms_key_id = replica.value.kms_key_id
    }
  }
  
  tags = merge(
    {
      Name        = "${var.app_name}-${each.key}"
      SecretType  = each.key
      Description = each.value.description
    },
    each.value.tags
  )
}

# Secret versions with values
resource "aws_secretsmanager_secret_version" "secret_values" {
  for_each = var.secrets
  
  secret_id = aws_secretsmanager_secret.secrets[each.key].id
  
  # Use generated password if specified, otherwise use provided secret_string
  secret_string = each.value.generate_password == true ? random_password.generated_secrets[each.key].result : each.value.secret_string
}

# Optional automatic rotation configuration
resource "aws_secretsmanager_secret_rotation" "secret_rotation" {
  for_each = var.enable_rotation ? var.secrets : {}
  
  secret_id           = aws_secretsmanager_secret.secrets[each.key].id
  rotation_lambda_arn = var.rotation_lambda_arn
  
  rotation_rules {
    automatically_after_days = 30
  }
  
  depends_on = [aws_secretsmanager_secret_version.secret_values]
} 