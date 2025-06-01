data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Default KMS key policy that allows root account access and key administration
data "aws_iam_policy_document" "default_key_policy" {
  for_each = var.kms_keys

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  # Allow additional principals if specified
  dynamic "statement" {
    for_each = length(var.grant_principals) > 0 ? [1] : []
    content {
      sid    = "Allow use of the key by additional principals"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.grant_principals
      }

      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ]

      resources = ["*"]
    }
  }

  # Allow CloudTrail to use the key if this is the secrets key
  dynamic "statement" {
    for_each = each.key == "secrets" ? [1] : []
    content {
      sid    = "Allow CloudTrail to encrypt logs"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["cloudtrail.amazonaws.com"]
      }

      actions = [
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]

      resources = ["*"]

      condition {
        test     = "StringEquals"
        variable = "kms:EncryptionContext:aws:cloudtrail:arn"
        values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/*"]
      }
    }
  }
} 