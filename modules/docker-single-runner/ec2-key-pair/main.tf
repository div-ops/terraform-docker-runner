resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.ec2_key.private_key_pem}' > ./${var.key_name}.pem"
  }
}

variable "key_name" {
  type = string
}

output "generated_key_key_name" {
  value = aws_key_pair.generated_key.key_name
}

output "tls_private_key_private_key_pem" {
  value = tls_private_key.ec2_key.private_key_pem
}
