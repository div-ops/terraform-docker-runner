module "security-group" {
  source              = "./security-group"
  security_group_name = var.security_group_name
  service_port_list   = var.service_ports
}

module "ec2-key-pair" {
  source   = "./ec2-key-pair"
  key_name = var.key_name
}

module "ec2-single-instance" {
  source             = "./ec2-single-instance"
  deploy_script_path = var.deploy_script_path
  dockerfile_path    = var.dockerfile_path
  tag_name           = var.tag_name
  hash               = var.hash
  local_exec         = var.local_exec

  remote_exec = [
    "export ${var.env_1_key}=${var.env_1_value}",
    "export ${var.env_2_key}=${var.env_2_value}",
    "export ${var.env_3_key}=${var.env_3_value}",
    "export ${var.env_4_key}=${var.env_4_value}",
    "export ${var.env_5_key}=${var.env_5_value}",
    "chmod +x /tmp/deploy.sh",
    "/tmp/deploy.sh",
  ]

  security_group_id = module.security-group.web_security_id
  key_name          = module.ec2-key-pair.generated_key_key_name
  private_key       = module.ec2-key-pair.tls_private_key_private_key_pem
}

module "route" {
  source          = "./route"
  route53_zone_id = var.hosted_zone_id
  domain_name     = var.domain_name
  alias_name      = module.alb.dns_name
  alias_zone_id   = module.alb.zone_id
}

module "alb" {
  source            = "./alb-for-ssl"
  security_group_id = module.security-group.web_security_id
  certificate_arn   = var.certificate_arn
  aws_instance_id   = module.ec2-single-instance.aws_instance_id
}

variable "hosted_zone_id" {
  type = string
}

variable "security_group_name" {
  type    = string
  default = "web_security"
}

variable "service_ports" {
  type = list(number)
}

variable "key_name" {
  type    = string
  default = "my-service"
}

variable "domain_name" {
  type = string
}

variable "deploy_script_path" {
  type = string
}

variable "dockerfile_path" {
  type = string
}

variable "env_1_key" {
  type    = string
  default = "env_1"
}

variable "env_1_value" {
  type = string
}

variable "env_2_key" {
  type    = string
  default = "env_2"
}

variable "env_2_value" {
  type = string
}

variable "env_3_key" {
  type    = string
  default = "env_3"
}

variable "env_3_value" {
  type = string
}
variable "env_4_key" {
  type    = string
  default = "env_4"
}

variable "env_4_value" {
  type = string
}
variable "env_5_key" {
  type    = string
  default = "env_5"
}

variable "env_5_value" {
  type = string
}

variable "tag_name" {
  type    = string
  default = "web"
}

variable "hash" {
  type    = string
  default = "init"
}

variable "local_exec" {
  type    = string
  default = "echo 'hello world!';"
}

variable "certificate_arn" {
  type = string
}

output "url" {
  value = "https://${module.ec2-single-instance.public_ip}"
}

output "domain_url" {
  value = "https://${var.domain_name}"
}
