resource "aws_route53_record" "web" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.ALIAS_NAME
    zone_id                = var.ALIAS_ZONE_ID
    evaluate_target_health = true
  }
}

variable "route53_zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}


variable "ALIAS_NAME" {
  type = string
}

variable "ALIAS_ZONE_ID" {
  type = string
}
