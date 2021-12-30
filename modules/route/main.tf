variable "ROUTE_WEB_DOMAIN" {
  type = string
}

variable "ROUTE_PRIMARY_DOMAIN" {
  type = string
}

variable "PUBLIC_IP" {
  type = string
}

# // 도메인 소유 Account 의 key 환경변수
# variable "DNS_AWS_ACCESS_KEY_ID" {
#   type = string
# }

# variable "DNS_AWS_SECRET_ACCESS_KEY" {
#   type = string
# }

resource "aws_route53_zone" "primary" {
  name = var.ROUTE_PRIMARY_DOMAIN
}

resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.ROUTE_WEB_DOMAIN
  type    = "A"
  ttl     = "300"
  records = [var.PUBLIC_IP]
}

output "name" {
  value = aws_route53_zone.primary.name_servers
}

# // 도메인 소유한 Account의 도메인의 Name Server를 새로 생성한 Host Zone으로 업데이트
# // TODO: aws-cli 의존성을 없앨 수 있을까?
# resource "null_resource" "modify_domain_name_servers" {
#   provisioner "local-exec" {
#     command     = "chmod +x ./dns-register.sh && bash ./dns-register.sh"
#     interpreter = ["/bin/bash", "-c"]
#     environment = {
#       AWS_ACCESS_KEY_ID     = var.DNS_AWS_ACCESS_KEY_ID
#       AWS_SECRET_ACCESS_KEY = var.DNS_AWS_SECRET_ACCESS_KEY
#       NAME_SERVER_0         = aws_route53_zone.primary.name_servers[0]
#       NAME_SERVER_1         = aws_route53_zone.primary.name_servers[1]
#       NAME_SERVER_2         = aws_route53_zone.primary.name_servers[2]
#       NAME_SERVER_3         = aws_route53_zone.primary.name_servers[3]
#     }
#   }
# }