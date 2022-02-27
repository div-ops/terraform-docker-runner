resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  tags = {
    Name = var.tag_name
  }
}

resource "null_resource" "web" {
  triggers = {
    instance_id = aws_instance.web.id
    hash        = var.hash
  }

  provisioner "local-exec" {
    command = var.local_exec
  }

  connection {
    type        = "ssh"
    host        = aws_instance.web.public_ip
    user        = "ec2-user"
    private_key = var.private_key
  }

  provisioner "file" {
    source      = var.deploy_script_path
    destination = "/tmp/deploy.sh"
  }

  provisioner "file" {
    source      = var.dockerfile_path
    destination = "/tmp/Dockerfile"
  }

  provisioner "file" {
    source      = var.target_path
    destination = "/tmp/target.tar.gz"
  }

  provisioner "remote-exec" {
    inline = var.remote_exec
  }

  provisioner "local-exec" {
    command = "rm -rf ${var.target_path}"
  }
}

variable "ami" {
  type    = string
  default = "ami-0eb14fe5735c13eb5"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "tag_name" {
  type    = string
  default = "terraform-web"
}

variable "dockerfile_path" {
  type    = string
  default = "Dockerfile"
}

variable "deploy_script_path" {
  type    = string
  default = "deploy.sh"
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "private_key" {
  type = string
}

variable "local_exec" {
  type    = string
  default = "echo 'hello world!';"
}

variable "target_path" {
  type = string
}
variable "remote_exec" {
  type = list(string)
}

variable "hash" {
  type    = string
  default = "init"
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "aws_instance_id" {
  value = aws_instance.web.id
}
