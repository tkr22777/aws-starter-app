# =============================================================================
# ECS Service Load Balancer Attachment
# =============================================================================

# Note: This resource updates the existing ECS service to attach it to the ALB target group
# The ECS service must already exist in the target cluster

resource "aws_ecs_service" "alb_integration" {
  # Reference the existing service and update it with load balancer configuration
  name            = var.ecs_service_name != "" ? var.ecs_service_name : "${var.app_name}-${var.environment}-service"
  cluster         = var.ecs_cluster_name != "" ? var.ecs_cluster_name : data.aws_ecs_cluster.main[0].name
  
  # Get the existing task definition from the service
  task_definition = data.aws_ecs_service.main[0].task_definition
  desired_count   = data.aws_ecs_service.main[0].desired_count
  launch_type     = "FARGATE"

  # Preserve existing network configuration
  network_configuration {
    security_groups  = data.aws_ecs_service.main[0].network_configuration[0].security_groups
    subnets          = data.aws_ecs_service.main[0].network_configuration[0].subnets
    assign_public_ip = data.aws_ecs_service.main[0].network_configuration[0].assign_public_ip
  }

  # Add load balancer configuration
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs.arn
    container_name   = var.container_name != "" ? var.container_name : var.app_name
    container_port   = var.container_port
  }

  # Ensure target group is created first
  depends_on = [aws_lb_target_group.ecs]

  tags = {
    Name        = "${var.app_name}-${var.environment}-service-alb"
    Environment = var.environment
    Project     = var.app_name
    Module      = "10a_ecs_alb"
    ManagedBy   = "terraform"
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to desired_count if auto-scaling is managing it
      desired_count,
      # Ignore changes to task_definition for rolling deployments
      task_definition
    ]
  }
} 