resource "aws_ecs_cluster" "app_ecs_cluster" {
  name = "app_ecs_cluster"
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_task_definition" "app_task" {
  family                   = "app_task_family"  // name for your task definition.
  network_mode             = "awsvpc"          // The networking mode; "awsvpc" enables each task to have its own network interface.
  requires_compatibilities = ["FARGATE"]       // Specifies the launch type, here it's FARGATE which abstracts server management.
  cpu                      = "256"             // The number of CPU units used by the task, with 1024 units = 1 vCPU.
  memory                   = "512"             // The amount of memory (in MiB) used by the task.
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn  // The IAM role that ECS tasks assume during execution.

  // defines the container specifications in the task
  container_definitions = jsonencode([
    {
      name      = "app_container"  // A unique name for your container within the task.
      image     = "${aws_ecr_repository.starter_app.repository_url}:latest" // The Docker image to use for the container.
      cpu       = 256  // The number of CPU units reserved for the container.
      memory    = 512  // The amount of memory (in MiB) reserved for the container.
      essential = true  // If true, all other containers are stopped if this container fails.
      portMappings = [
        {
          containerPort = 80  // The port on the container to bind to.
          hostPort      = 80  // The port on the host to bind to, often the same as containerPort in awsvpc mode.
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app_service" {
  name            = "app_service"
  cluster         = aws_ecs_cluster.app_ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.app_sn.id]  // subnet ID for ECS tasks
    security_groups = [aws_security_group.ec2_sg.id]  // security group designed for service
    assign_public_ip = true  // true if you need public IP addresses for your tasks
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_execution_role_policy]
}