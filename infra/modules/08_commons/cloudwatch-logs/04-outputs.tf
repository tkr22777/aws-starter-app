output "log_group_names" {
  description = "Map of log group names"
  value       = { for k, v in aws_cloudwatch_log_group.log_groups : k => v.name }
}

output "log_group_arns" {
  description = "Map of log group ARNs"
  value       = { for k, v in aws_cloudwatch_log_group.log_groups : k => v.arn }
}

output "metric_filter_names" {
  description = "Map of metric filter names"
  value       = { for k, v in aws_cloudwatch_log_metric_filter.metric_filters : k => v.name }
}

output "subscription_filter_names" {
  description = "Map of subscription filter names"
  value       = { for k, v in aws_cloudwatch_log_subscription_filter.subscription_filters : k => v.name }
}

# Convenient outputs for specific log groups
output "app_log_group_name" {
  description = "Application log group name"
  value       = try(aws_cloudwatch_log_group.log_groups["app"].name, null)
}

output "api_log_group_name" {
  description = "API log group name"
  value       = try(aws_cloudwatch_log_group.log_groups["api"].name, null)
}

output "database_log_group_name" {
  description = "Database log group name"
  value       = try(aws_cloudwatch_log_group.log_groups["database"].name, null)
}

output "security_log_group_name" {
  description = "Security log group name"
  value       = try(aws_cloudwatch_log_group.log_groups["security"].name, null)
}

output "audit_log_group_name" {
  description = "Audit log group name"
  value       = try(aws_cloudwatch_log_group.log_groups["audit"].name, null)
}

# Query definitions
output "insights_query_names" {
  description = "List of CloudWatch Logs Insights query names"
  value = compact([
    try(aws_cloudwatch_query_definition.common_queries[0].name, ""),
    try(aws_cloudwatch_query_definition.performance_queries[0].name, ""),
    try(aws_cloudwatch_query_definition.security_queries[0].name, "")
  ])
}

# CLI commands
output "aws_cli_commands" {
  description = "Useful AWS CLI commands for CloudWatch Logs"
  value = {
    list_log_groups = "aws logs describe-log-groups --log-group-name-prefix '/aws/${var.app_name}'"
    tail_app_logs = try("aws logs tail ${aws_cloudwatch_log_group.log_groups["app"].name} --follow", "App log group not created")
    tail_api_logs = try("aws logs tail ${aws_cloudwatch_log_group.log_groups["api"].name} --follow", "API log group not created")
    search_errors = try("aws logs filter-log-events --log-group-name ${aws_cloudwatch_log_group.log_groups["app"].name} --filter-pattern ERROR", "App log group not created")
    insights_query = "aws logs start-query --log-group-names '/aws/${var.app_name}/app' --start-time $(date -d '1 hour ago' +%s) --end-time $(date +%s) --query-string 'fields @timestamp, @message | filter level = \"ERROR\"'"
  }
}

# Log streaming commands for different languages/frameworks
output "log_streaming_examples" {
  description = "Examples for streaming logs to CloudWatch from applications"
  value = {
    python_boto3 = <<-EOT
      import boto3
      import json
      from datetime import datetime
      
      client = boto3.client('logs')
      
      def log_to_cloudwatch(message, level='INFO'):
          client.put_log_events(
              logGroupName='${try(aws_cloudwatch_log_group.log_groups["app"].name, "/aws/the-awesome-app/app")}',
              logStreamName=f'instance-{datetime.now().strftime("%Y-%m-%d")}',
              logEvents=[{
                  'timestamp': int(datetime.now().timestamp() * 1000),
                  'message': json.dumps({
                      'timestamp': datetime.now().isoformat(),
                      'level': level,
                      'message': message
                  })
              }]
          )
    EOT
    
    nodejs_winston = <<-EOT
      const winston = require('winston');
      const WinstonCloudWatch = require('winston-cloudwatch');
      
      const logger = winston.createLogger({
        transports: [
          new WinstonCloudWatch({
            logGroupName: '${try(aws_cloudwatch_log_group.log_groups["app"].name, "/aws/the-awesome-app/app")}',
            logStreamName: 'app-' + new Date().toISOString().split('T')[0],
            awsRegion: 'us-east-1'
          })
        ]
      });
      
      logger.info('Application started');
      logger.error('An error occurred', { error: 'details' });
    EOT
    
    docker_awslogs = <<-EOT
      # Docker run command with AWS logs driver
      docker run --log-driver=awslogs \
        --log-opt awslogs-group=${try(aws_cloudwatch_log_group.log_groups["app"].name, "/aws/the-awesome-app/app")} \
        --log-opt awslogs-region=us-east-1 \
        --log-opt awslogs-stream=container-instance \
        your-app-image
    EOT
    
    ec2_cloudwatch_agent = <<-EOT
      # CloudWatch Agent config for EC2
      {
        "logs": {
          "logs_collected": {
            "files": {
              "collect_list": [
                {
                  "file_path": "/var/log/app.log",
                  "log_group_name": "${try(aws_cloudwatch_log_group.log_groups["app"].name, "/aws/the-awesome-app/app")}",
                  "log_stream_name": "ec2-{instance_id}",
                  "timestamp_format": "%Y-%m-%d %H:%M:%S"
                }
              ]
            }
          }
        }
      }
    EOT
  }
}

# Account and region info
output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "region" {
  description = "AWS Region"
  value       = data.aws_region.current.name
} 