# KMS Keys
resource "aws_kms_key" "keys" {
  for_each = var.kms_keys

  description             = each.value.description
  key_usage              = each.value.key_usage
  deletion_window_in_days = each.value.deletion_window_in_days
  enable_key_rotation     = each.value.enable_key_rotation
  multi_region           = each.value.multi_region

  policy = each.value.policy != null ? each.value.policy : data.aws_iam_policy_document.default_key_policy[each.key].json

  tags = merge(
    local.common_tags,
    each.value.tags,
    {
      Name = "${var.app_name}-${each.key}-key"
      KeyPurpose = each.key
    }
  )
}

# KMS Aliases
resource "aws_kms_alias" "aliases" {
  for_each = {
    for combination in flatten([
      for key_name, key_config in var.kms_keys : [
        for alias in key_config.aliases : {
          key_name   = key_name
          alias_name = alias
          key_id     = aws_kms_key.keys[key_name].key_id
        }
      ]
    ]) : "${combination.key_name}-${combination.alias_name}" => combination
  }

  name          = "alias/${var.app_name}-${each.value.alias_name}"
  target_key_id = each.value.key_id
} 