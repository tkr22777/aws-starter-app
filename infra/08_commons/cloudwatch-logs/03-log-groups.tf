# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "log_groups" {
  for_each = var.log_groups

  name              = "${local.log_group_prefix}/${each.key}"
  retention_in_days = each.value.retention_in_days
  kms_key_id        = each.value.kms_key_id

  tags = merge(
    local.common_tags,
    each.value.tags,
    {
      Name        = "${var.app_name}-${each.key}-logs"
      LogType     = each.key
      Service     = each.key
    }
  )
}

# Metric Filters for alerting
resource "aws_cloudwatch_log_metric_filter" "metric_filters" {
  for_each = var.metric_filters

  name           = "${var.app_name}-${each.key}"
  log_group_name = aws_cloudwatch_log_group.log_groups[each.value.log_group_name].name
  pattern        = each.value.filter_pattern

  metric_transformation {
    name          = each.value.metric_name
    namespace     = each.value.metric_namespace
    value         = each.value.metric_value
    default_value = each.value.default_value
  }
}

# Subscription Filters for real-time processing
resource "aws_cloudwatch_log_subscription_filter" "subscription_filters" {
  for_each = var.subscription_filters

  name            = "${var.app_name}-${each.key}"
  log_group_name  = aws_cloudwatch_log_group.log_groups[each.value.log_group_name].name
  filter_pattern  = each.value.filter_pattern
  destination_arn = each.value.destination_arn
  role_arn        = each.value.role_arn
}

# IAM role for subscription filters (if needed)
resource "aws_iam_role" "logs_subscription_role" {
  count = length(var.subscription_filters) > 0 ? 1 : 0

  name               = "${var.app_name}-logs-subscription-role"
  assume_role_policy = data.aws_iam_policy_document.logs_subscription_assume_role.json

  tags = local.common_tags
}

resource "aws_iam_role_policy" "logs_subscription_policy" {
  count = length(var.subscription_filters) > 0 ? 1 : 0

  name   = "${var.app_name}-logs-subscription-policy"
  role   = aws_iam_role.logs_subscription_role[0].id
  policy = data.aws_iam_policy_document.logs_subscription_policy.json
}

# Log Insights Queries (stored for convenience)
resource "aws_cloudwatch_query_definition" "common_queries" {
  count = var.enable_insights ? 1 : 0

  name = "${var.app_name}-common-error-analysis"

  log_group_names = [
    aws_cloudwatch_log_group.log_groups["app"].name,
    aws_cloudwatch_log_group.log_groups["api"].name
  ]

  query_string = <<-EOT
    fields @timestamp, @message, level, request_id
    | filter level = "ERROR"
    | sort @timestamp desc
    | limit 100
  EOT
}

resource "aws_cloudwatch_query_definition" "performance_queries" {
  count = var.enable_insights ? 1 : 0

  name = "${var.app_name}-performance-analysis"

  log_group_names = [
    aws_cloudwatch_log_group.log_groups["api"].name,
    aws_cloudwatch_log_group.log_groups["database"].name
  ]

  query_string = <<-EOT
    fields @timestamp, @message, duration, endpoint
    | filter duration > 1000
    | sort duration desc
    | limit 50
  EOT
}

resource "aws_cloudwatch_query_definition" "security_queries" {
  count = var.enable_insights ? 1 : 0

  name = "${var.app_name}-security-events"

  log_group_names = [
    aws_cloudwatch_log_group.log_groups["security"].name,
    aws_cloudwatch_log_group.log_groups["audit"].name
  ]

  query_string = <<-EOT
    fields @timestamp, @message, user_id, action, ip_address
    | filter action like /login|logout|delete|admin/
    | sort @timestamp desc
    | limit 100
  EOT
} 