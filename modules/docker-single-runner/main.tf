module "security-group" {
  source              = "../security-group"
  SECURITY_GROUP_NAME = var.security_group_name
  SERVICE_PORT_LIST   = var.service_ports
}

module "ec2-key-pair" {
  source   = "../ec2-key-pair"
  KEY_NAME = var.key_name
}

module "ec2-single-instance" {
  source             = "../ec2-single-instance"
  DEPLOY_SCRIPT_PATH = var.deploy_script_path
  DOCKERFILE_PATH    = var.dockerfile_path
  TAG_NAME           = var.tag_name
  VERSION            = var.hash
  REMOTE_EXEC = [
    "export GIT_TOKEN=${var.git_token}",
    "chmod +x /tmp/deploy.sh",
    "/tmp/deploy.sh",
  ]

  SECURITY_GROUP_ID = module.security-group.web_security_id
  KEY_NAME          = module.ec2-key-pair.generated_key_key_name
  PRIVATE_KEY       = module.ec2-key-pair.tls_private_key_private_key_pem
}

module "route" {
  source          = "../route"
  route53_zone_id = var.hosted_zone_id
  domain_name     = var.domain_name
  ALIAS_NAME      = module.alb.dns_name
  ALIAS_ZONE_ID   = module.alb.zone_id
}

module "alb" {
  source            = "../alb-for-ssl"
  security_group_id = module.security-group.web_security_id
  certificate_arn   = var.certificate_arn
  aws_instance_id   = module.ec2-single-instance.aws_instance_id
}

output "URL" {
  value = "https://${module.ec2-single-instance.public_ip}"
}

output "DOMAIN_URL" {
  value = "https://${var.domain_name}"
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

variable "git_token" {
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

variable "certificate_arn" {
  type = string
}
