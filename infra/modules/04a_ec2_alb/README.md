# EC2-ALB Integration

This module handles the integration between EC2 instances and Application Load Balancers, creating target groups and routing rules.

## Resources Created

- **Target Group** (`aws_lb_target_group.ec2_tg`)
  - HTTP target group for EC2 instances
  - Configurable health checks
  - Tagged for easy identification

- **Target Group Attachment** (`aws_lb_target_group_attachment.ec2_attachment`)
  - Registers EC2 instance with target group
  - Configurable port mapping

- **ALB Listener Rule** (`aws_lb_listener_rule.ec2_rule`)
  - Routes traffic based on path patterns
  - Configurable priority and routing logic

## Usage

This module is designed to be deployed **after** the EC2 module and **when** an ALB is available:

```hcl
module "ec2_alb" {
  source = "../../modules/04a_ec2_alb"
  
  # Required: EC2 instance to integrate
  ec2_instance_id = "i-1234567890abcdef0"
  
  # Optional: Routing configuration  
  api_path_prefix = "/api/*"
  listener_rule_priority = 200
  
  # Optional: Health check tuning
  health_check_interval = 30
  health_check_timeout = 5
}
```

## Architecture Pattern

This follows the **separation of concerns** principle:
- `04_ec2/` - Pure EC2 infrastructure
- `04a_ec2_alb/` - ALB ↔ EC2 integration
- `02a_alb/` - ALB infrastructure (when created)

## Dependencies

- Network module (VPC)
- EC2 module (instance)
- ALB module (listener) - optional, can discover via data sources 