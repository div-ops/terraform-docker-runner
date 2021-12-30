// 도메인 소유 Account 의 key 환경변수
variable "SECURITY_GROUP_NAME" {
  type = string
}

// security group
variable "SERVICE_PORT_LIST" {
  type    = list(number)
  default = [22, 3000]
}

resource "aws_security_group" "web_security" {
  name        = var.SECURITY_GROUP_NAME
  description = var.SECURITY_GROUP_NAME
  dynamic "ingress" {
    for_each = var.SERVICE_PORT_LIST
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

output "web_security_id" {
  value = aws_security_group.web_security.id
}