# ECS ALB Integration Module

Integrates an existing ECS service with an Application Load Balancer for high availability and load distribution.

## Purpose

This module creates the necessary ALB target group and listener rules to route traffic to an existing ECS service. It's designed to work with the standalone ECS module (`10_ecs`) to add load balancing capabilities.

## Resources Created

- **Target Group**: IP-based target group for ECS tasks
- **Listener Rule**: Path-based routing rule for ALB
- **Service Integration**: Updates ECS service with load balancer configuration

## Configuration

### Basic Usage

```hcl
module "ecs_alb" {
  source = "../../../modules/10a_ecs_alb"
  
  app_name    = "my-app"
  environment = "prod"
  
  # ECS service to integrate
  ecs_cluster_name = "my-app-prod-cluster"
  ecs_service_name = "my-app-prod-service"
  
  # ALB configuration
  path_pattern = "/api/*"
  container_port = 80
}
```

### Advanced Configuration

```hcl
module "ecs_alb" {
  source = "../../../modules/10a_ecs_alb"
  
  # Custom health checks
  health_check_path     = "/health"
  health_check_interval = 30
  healthy_threshold     = 2
  
  # Custom routing
  path_pattern     = "/api/v1/*"
  host_header      = "api.example.com"
  listener_priority = 100
  
  # Target group settings
  deregistration_delay = 30
}
```

## Integration Pattern

1. **Deploy ECS Service**: Use `10_ecs` module for standalone service
2. **Deploy ALB Integration**: Use this module to add load balancing
3. **Test Routing**: Verify traffic flows through ALB to ECS tasks

## Health Checks

- **Path**: Configurable health check endpoint
- **Interval**: 30 seconds (configurable)
- **Thresholds**: 2 healthy, 3 unhealthy (configurable)
- **Matcher**: HTTP 200 response codes (configurable)

## Outputs

- Target group ARN and configuration
- ALB listener rule details
- Test endpoints and CLI commands
- Health check configuration

## Dependencies

- Existing ECS cluster and service
- Existing Application Load Balancer
- VPC with proper networking setup 