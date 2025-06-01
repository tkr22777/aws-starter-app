# ECS Cluster
resource "aws_ecs_cluster" "app_cluster" {
  name = "${var.app_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-cluster"
    Environment = var.environment
    Project     = var.app_name
    Module      = "10_ecs"
    ManagedBy   = "terraform"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.app_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn           = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = var.app_name
      image     = var.container_image != "" ? var.container_image : "${data.aws_ecr_repository.app_repo[0].repository_url}:${var.container_tag}"
      essential = true
      
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }

      environment = [
        {
          name  = "APP_NAME"
          value = var.app_name
        },
        {
          name  = "ENVIRONMENT"
          value = var.environment
        },
        {
          name  = "PORT"
          value = tostring(var.container_port)
        }
      ]
    }
  ])

  tags = {
    Name        = "${var.app_name}-${var.environment}-task-definition"
    Environment = var.environment
    Project     = var.app_name
    Module      = "10_ecs"
    ManagedBy   = "terraform"
  }
}

# ECS Service (Standalone - No ALB)
resource "aws_ecs_service" "app_service" {
  name            = "${var.app_name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  
  enable_execute_command = var.enable_execute_command

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    subnets          = [var.subnet_id != "" ? var.subnet_id : data.aws_subnet.main_subnet[0].id]
    assign_public_ip = var.assign_public_ip
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-service"
    Environment = var.environment
    Project     = var.app_name
    Module      = "10_ecs"
    ManagedBy   = "terraform"
  }
}

# Auto Scaling Target (Conditional)
resource "aws_appautoscaling_target" "ecs_target" {
  count = var.enable_auto_scaling ? 1 : 0

  max_capacity       = var.max_capacity
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.app_cluster.name}/${aws_ecs_service.app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Auto Scaling Policy - CPU (Conditional)
resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  count = var.enable_auto_scaling ? 1 : 0

  name               = "${var.app_name}-${var.environment}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = var.cpu_target_value
  }
}

# Auto Scaling Policy - Memory (Conditional)
resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  count = var.enable_auto_scaling ? 1 : 0

  name               = "${var.app_name}-${var.environment}-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = var.memory_target_value
  }
} 