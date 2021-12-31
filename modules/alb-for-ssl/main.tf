variable "vpc_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "certificate_arn" {
  type = string
}

variable "aws_instance_id" {
  type = string
}

resource "aws_lb" "alb_for_ssl" {
  name               = "alb-for-ssl"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnets

  tags = {
    Type = "alb-for-ssl"
  }
}

resource "aws_lb_target_group" "alb_target" {
  name        = "web"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    port     = "traffic-port"
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "alb_target_instances" {
  target_group_arn = aws_lb_target_group.alb_target.arn
  target_id        = var.aws_instance_id
  port             = 80
}


resource "aws_lb_listener" "redirect_listener_80" {
  load_balancer_arn = aws_lb.alb_for_ssl.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_302"
    }
  }
}

resource "aws_lb_listener" "forward_listener_443" {
  load_balancer_arn = aws_lb.alb_for_ssl.id
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target.arn
  }
}

output "dns_name" {
  value = aws_lb.alb_for_ssl.dns_name
}

output "zone_id" {
  value = aws_lb.alb_for_ssl.zone_id
}
