variable "ZONE_ID" {
  type = string
}

variable "DOMAIN_NAME" {
  type = string
}

resource "aws_acm_certificate" "acm" {
  domain_name = var.DOMAIN_NAME
  # subject_alternative_names = ["*.${var.DOMAIN_NAME}"]
  validation_method = "DNS"
}

resource "aws_route53_record" "acm_record" {
  for_each = {
    for option in aws_acm_certificate.acm.domain_validation_options : option.domain_name => {
      name   = option.resource_record_name
      record = option.resource_record_value
      type   = option.resource_record_type
    }
  }

  # allow_overwrite = true
  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = var.ZONE_ID
}

resource "aws_acm_certificate_validation" "acm_validation" {
  certificate_arn         = aws_acm_certificate.acm.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_record : record.fqdn]

  lifecycle {
    create_before_destroy = true
  }
}

output "acm_certificate_dns_validation_records" {
  description = "record which is used to validate acm certificate"
  value       = aws_acm_certificate.acm.*.domain_validation_options
}

output "arn" {
  value = aws_acm_certificate.acm.arn
}
