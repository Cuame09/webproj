# KEY PAIR

resource "aws_key_pair" "webprojkp" {
  key_name   = "webprojkp"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "WEB-PROJ-KP" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "webprojkp"
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}