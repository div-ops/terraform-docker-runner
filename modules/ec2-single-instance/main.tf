
resource "aws_instance" "web" {
  ami                    = var.AMI
  instance_type          = var.TYPE
  vpc_security_group_ids = [var.SECURITY_GROUP_ID]
  key_name               = var.KEY_NAME
  tags = {
    Name = var.TAG_NAME
  }
}

resource "null_resource" "web" {
  triggers = {
    instance_id = aws_instance.web.id
    version     = var.VERSION
  }

  connection {
    type        = "ssh"
    host        = aws_instance.web.public_ip
    user        = "ec2-user"
    private_key = var.PRIVATE_KEY
  }

  provisioner "file" {
    source      = var.DEPLOY_SCRIPT_PATH
    destination = "/tmp/deploy.sh"
  }

  provisioner "file" {
    source      = var.DOCKERFILE_PATH
    destination = "/tmp/Dockerfile"
  }

  provisioner "remote-exec" {
    inline = var.REMOTE_EXEC
  }
}

variable "AMI" {
  type    = string
  default = "ami-0eb14fe5735c13eb5"
}
variable "TYPE" {
  type    = string
  default = "t2.micro"
}
variable "TAG_NAME" {
  type    = string
  default = "terraform-web"
}
variable "DOCKERFILE_PATH" {
  type    = string
  default = "Dockerfile"
}
variable "DEPLOY_SCRIPT_PATH" {
  type    = string
  default = "deploy.sh"
}
variable "SECURITY_GROUP_ID" {
  type = string
}
variable "KEY_NAME" {
  type = string
}
variable "PRIVATE_KEY" {
  type = string
}
variable "REMOTE_EXEC" {
  type = list(string)
}

variable "VERSION" {
  type    = string
  default = "init"
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
