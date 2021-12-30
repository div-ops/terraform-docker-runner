variable "ROUTE_WEB_DOMAIN" {
  type = string
}

variable "ROUTE_PRIMARY_DOMAIN" {
  type = string
}

variable "PUBLIC_IP" {
  type = string
}

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

output "name_servers" {
  value = aws_route53_zone.primary.name_servers
}
