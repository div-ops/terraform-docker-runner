provider "aws" {
  region = var.region
}

variable "region" {
  default = "ap-northeast-2"
}

variable "service_ports" {
  default = [22, 3000]
}

module "security-group" {
  source              = "./modules/security-group"
  SECURITY_GROUP_NAME = "web_security"
  SERVICE_PORT_LIST   = [22, 3000]
}

variable "KEY_NAME" {
  type    = string
  default = "my-service"
}

module "ec2-key-pair" {
  source   = "./modules/ec2-key-pair"
  KEY_NAME = var.KEY_NAME
}

module "ec2-single-instance" {
  source            = "./modules/ec2-single-instance"
  SECURITY_GROUP_ID = module.security-group.web_security_id
  KEY_NAME          = module.ec2-key-pair.generated_key_key_name
  PRIVATE_KEY       = module.ec2-key-pair.tls_private_key_private_key_pem
  REMOTE_EXEC       = ["chmod +x /tmp/deploy.sh", "/tmp/deploy.sh"]
}

module "route" {
  source               = "./modules/route"
  PUBLIC_IP            = module.ec2-single-instance.public_ip
  ROUTE_WEB_DOMAIN     = "creco.me"
  ROUTE_PRIMARY_DOMAIN = "creco.me"
}

output "welcome_to_my_web" {
  # value = "http://creco.me:3000"
  value = "http://${module.ec2-single-instance.public_ip}:3000"
}

output "name_servers" {
  value = module.route.name_servers
}
