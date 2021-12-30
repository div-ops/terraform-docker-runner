provider "aws" {
  region = var.region
}

variable "region" {
  default = "ap-northeast-2"
}

// security group
variable "service_ports" {
  default = [22, 3000]
}

module "security-group" {
  source = "./modules/security-group"

  SECURITY_GROUP_NAME = "web_security"
  SERVICE_PORT_LIST   = [22, 3000]
}

variable "KEY_NAME" {
  type    = string
  default = "my-service"
}

module "ec2-key-pair" {
  source = "./modules/ec2-key-pair"

  KEY_NAME = var.KEY_NAME
}

// EC2 Instance
resource "aws_instance" "web" {
  ami                    = "ami-0eb14fe5735c13eb5"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.security-group.web_security_id]
  key_name               = module.ec2-key-pair.generated_key_key_name
  tags = {
    Name = "terraform-web"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = module.ec2-key-pair.tls_private_key_private_key_pem
  }

  # provisioner "local-exec" {
  #   command     = "chmod +x ./predeploy.sh && bash ./predeploy.sh"
  #   interpreter = ["/bin/bash", "-c"]
  # }

  provisioner "file" {
    source      = "deploy.sh"
    destination = "/tmp/deploy.sh"
  }

  provisioner "file" {
    source      = "Dockerfile"
    destination = "/tmp/Dockerfile"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/deploy.sh",
      "/tmp/deploy.sh",
    ]
  }
}

module "route" {
  source = "./modules/route"

  PUBLIC_IP            = aws_instance.web.public_ip
  ROUTE_WEB_DOMAIN     = "creco.me"
  ROUTE_PRIMARY_DOMAIN = "creco.me"
}

// 접속 경로 output
output "welcome_to_my_web" {
  # value = "http://creco.me:3000"
  value = "http://${aws_instance.web.public_ip}:3000"
}

