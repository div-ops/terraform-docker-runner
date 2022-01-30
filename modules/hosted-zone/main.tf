variable "domain_name" {
  description = "hosted zone's main domain name"
  type        = string
}

resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

output "name_servers" {
  value = aws_route53_zone.primary.name_servers
}

output "zone_id" {
  value = aws_route53_zone.primary.zone_id
}
