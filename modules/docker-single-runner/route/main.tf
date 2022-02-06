resource "aws_route53_record" "web" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = true
  }
}

variable "alias_name" {
  type = string
}

variable "alias_zone_id" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}
