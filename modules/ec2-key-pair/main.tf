// EC2 key pair
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  key_name   = var.KEY_NAME
  public_key = tls_private_key.ec2_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.ec2_key.private_key_pem}' > ./${var.KEY_NAME}.pem"
  }

}

output "generated_key_key_name" {
  value = aws_key_pair.generated_key.key_name
}

output "tls_private_key_private_key_pem" {
  value = tls_private_key.ec2_key.private_key_pem
}
variable "KEY_NAME" {
  type = string
}
