# =============================================================================
# ALB Core Information
# =============================================================================
output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.app_alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the Application Load Balancer"
  value       = aws_lb.app_alb.zone_id
}

output "alb_hosted_zone_id" {
  description = "The canonical hosted zone ID of the ALB (for Route53 alias records)"
  value       = aws_lb.app_alb.zone_id
}

# =============================================================================
# ALB Listener Information
# =============================================================================
output "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  value       = aws_lb_listener.app_listener.arn
}

output "default_target_group_arn" {
  description = "The ARN of the default target group"
  value       = aws_lb_target_group.default_tg.arn
}

# =============================================================================
# Security Information
# =============================================================================
output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

# =============================================================================
# Application URLs
# =============================================================================
output "application_url" {
  description = "The application URL (ALB DNS name)"
  value       = "http://${aws_lb.app_alb.dns_name}"
}

output "load_balancer_dns" {
  description = "Load balancer DNS name for CNAME records"
  value       = aws_lb.app_alb.dns_name
}

# =============================================================================
# CLI Examples
# =============================================================================
output "curl_test_command" {
  description = "Command to test the ALB default response"
  value       = "curl -v http://${aws_lb.app_alb.dns_name}"
}

output "aws_cli_describe_command" {
  description = "AWS CLI command to describe the load balancer"
  value       = "aws elbv2 describe-load-balancers --load-balancer-arns ${aws_lb.app_alb.arn}"
}

output "aws_cli_describe_listeners_command" {
  description = "AWS CLI command to describe ALB listeners"
  value       = "aws elbv2 describe-listeners --load-balancer-arn ${aws_lb.app_alb.arn}"
}

output "aws_cli_describe_target_groups_command" {
  description = "AWS CLI command to describe target groups"
  value       = "aws elbv2 describe-target-groups --load-balancer-arn ${aws_lb.app_alb.arn}"
}

# =============================================================================
# Integration Information
# =============================================================================
output "integration_example" {
  description = "Example configuration for integrating services with this ALB"
  value = {
    alb_arn           = aws_lb.app_alb.arn
    listener_arn      = aws_lb_listener.app_listener.arn
    vpc_id            = local.vpc_id
    security_group_id = aws_security_group.alb_sg.id
    dns_name          = aws_lb.app_alb.dns_name
    zone_id           = aws_lb.app_alb.zone_id
  }
} 