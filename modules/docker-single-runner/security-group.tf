resource "aws_security_group" "web_security" {
  name        = var.security_group_name
  description = var.security_group_name
  dynamic "ingress" {
    for_each = var.service_port_list
    content {
      description      = "Port: ${ingress.value}"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

variable "security_group_name" {
  type = string
}

variable "service_port_list" {
  type    = list(number)
  default = [22, 80, 443]
}

output "web_security_id" {
  value = aws_security_group.web_security.id
}

