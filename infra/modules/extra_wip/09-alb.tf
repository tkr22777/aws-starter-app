# TODO
# ## alb security group
# resource "aws_security_group" "alb_sg" {
#   name        = "alb-sg"
#   description = "Allow web inbound traffic"
#   vpc_id      = your_vpc_id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 1
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# ## alb
# resource "aws_lb" "my_alb" {
#   name               = "my-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [aws_subnet.app_sn.id]  // subnet ID for ECS tasks
# }

# resource "aws_lb_target_group" "my_tg" {
#   name     = "my-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = "${aws_vpc.test_env.id}"
# }

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.my_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.my_tg.arn
#   }
# }

