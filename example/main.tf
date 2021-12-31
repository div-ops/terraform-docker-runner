provider "aws" {
  region = var.region
}

variable "region" {
  default = "ap-northeast-2"
}

variable "GIT_TOKEN" {
  type = string
}

module "docker-single-runner" {
  source              = "git::https://github.com/div-ops/terraform-docker-runner.git//modules/docker-single-runner"
  SECURITY_GROUP_NAME = "web_security"
  SERVICE_PORTS       = [22, 80, 443]
  KEY_NAME            = "my-service"
  DOMAIN              = "creco.me"
  DEPLOY_SCRIPT_PATH  = "deploy.sh"
  DOCKERFILE_PATH     = "Dockerfile"
  GIT_TOKEN           = var.GIT_TOKEN
  VERSION             = uuid()
}

output "URL" {
  value = module.docker-single-runner.URL
}

output "DOMAIN_URL" {
  value = module.docker-single-runner.DOMAIN_URL
}

output "REGISTER_NS" {
  value = module.docker-single-runner.REGISTER_NS
}

