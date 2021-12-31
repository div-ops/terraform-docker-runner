variable "ROUTE_WEB_DOMAIN" {
  type = string
}

variable "ROUTE_PRIMARY_DOMAIN" {
  type = string
}

variable "ALIAS_NAME" {
  type = string
}

variable "ALIAS_ZONE_ID" {
  type = string
}

resource "aws_route53_zone" "primary" {
  name = var.ROUTE_PRIMARY_DOMAIN
}

resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.ROUTE_WEB_DOMAIN
  type    = "A"
  alias {
    name                   = var.ALIAS_NAME
    zone_id                = var.ALIAS_ZONE_ID
    evaluate_target_health = true
  }
}

output "name_servers" {
  value = aws_route53_zone.primary.name_servers
}

output "zone_id" {
  value = aws_route53_zone.primary.zone_id
}
