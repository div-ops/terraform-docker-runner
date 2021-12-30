variable "SECURITY_GROUP_NAME" {
  type    = string
  default = "web_security"
}

variable "SERVICE_PORTS" {
  type = list(number)
}

variable "KEY_NAME" {
  type    = string
  default = "my-service"
}

variable "DOMAIN" {
  type = string
}

variable "DEPLOY_SCRIPT_PATH" {
  type = string
}

variable "DOCKERFILE_PATH" {
  type = string
}

variable "GIT_TOKEN" {
  type = string
}

module "security-group" {
  source              = "../security-group"
  SECURITY_GROUP_NAME = var.SECURITY_GROUP_NAME
  SERVICE_PORT_LIST   = var.SERVICE_PORTS
}

module "ec2-key-pair" {
  source   = "../ec2-key-pair"
  KEY_NAME = var.KEY_NAME
}

module "ec2-single-instance" {
  source             = "../ec2-single-instance"
  DEPLOY_SCRIPT_PATH = var.DEPLOY_SCRIPT_PATH
  DOCKERFILE_PATH    = var.DOCKERFILE_PATH
  REMOTE_EXEC = [
    "export GIT_TOKEN=${var.GIT_TOKEN}",
    "chmod +x /tmp/deploy.sh",
    "/tmp/deploy.sh",
  ]

  SECURITY_GROUP_ID = module.security-group.web_security_id
  KEY_NAME          = module.ec2-key-pair.generated_key_key_name
  PRIVATE_KEY       = module.ec2-key-pair.tls_private_key_private_key_pem
}

module "route" {
  source               = "../route"
  ROUTE_WEB_DOMAIN     = var.DOMAIN
  ROUTE_PRIMARY_DOMAIN = var.DOMAIN

  PUBLIC_IP = module.ec2-single-instance.public_ip
}

output "URL" {
  value = "http://${module.ec2-single-instance.public_ip}"
}

output "DOMAIN_URL" {
  value = "http://${var.DOMAIN}"
}

output "REGISTER_NS" {
  value = module.route.name_servers
}
