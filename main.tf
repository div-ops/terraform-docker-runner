provider "aws" {
  region = var.region
}

variable "region" {
  default = "ap-northeast-2"
}

module "docker-single-runner" {
  source              = "./modules/docker-single-runner"
  SECURITY_GROUP_NAME = "web_security"
  SERVICE_PORTS       = [22, 80]
  KEY_NAME            = "my-service"
  DOMAIN              = "creco.me"
  DEPLOY_SCRIPT_PATH  = "deploy.sh"
  DOCKERFILE_PATH     = "Dockerfile"
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

