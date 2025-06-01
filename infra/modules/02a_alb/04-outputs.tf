# ALB outputs for use by other modules
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

output "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  value       = aws_lb_listener.app_listener.arn
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "application_url" {
  description = "The application URL (ALB DNS name)"
  value       = "http://${aws_lb.app_alb.dns_name}"
}

# CLI examples
output "curl_test_command" {
  description = "Command to test the ALB"
  value       = "curl http://${aws_lb.app_alb.dns_name}"
} 