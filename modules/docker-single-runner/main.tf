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
  source             = "../ec2-single-instance"
  deploy_script_path = var.deploy_script_path
  dockerfile_path    = var.dockerfile_path
  tag_name           = var.tag_name
  hash               = var.hash
  remote_exec = [
    "export GIT_TOKEN=${var.git_token}",
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

output "url" {
  value = "https://${module.ec2-single-instance.public_ip}"
}

output "domain_url" {
  value = "https://${var.domain_name}"
}
