resource "tls_private_key" "cice_key_usa" {
  algorithm = "RSA"
  rsa_bits  = 1024

  provider = tls.private_key
}

resource "local_file" "cice_pem_usa" {
  filename        = "./cice-tf-usa.pem"
  file_permission = "0400"
  content         = tls_private_key.cice_key_usa.private_key_pem
}

resource "aws_key_pair" "cice_generated_key_usa" {
  key_name   = "cice-tf-usa"
  public_key = tls_private_key.cice_key_usa.public_key_openssh

  provider = aws.usa
}

resource "aws_instance" "cice_usa" {
  ami                    = data.aws_ami.amazon_linux_usa.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.cice_generated_key_usa.key_name
  vpc_security_group_ids = [aws_security_group.cice_usa_sg.id]

  provider = aws.usa

  tags = {
    Name = "CICE Instance"
  }
}


resource "aws_security_group" "cice_usa_sg" {
  name        = "CICE SG"
  description = "CICE Security Group created by Terraform"

  provider = aws.usa

  tags = {
    "Name" = "CICE_SG"
  }
}

resource "aws_security_group_rule" "cice_ssh_usa" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cice_usa_sg.id

  provider = aws.usa
}

resource "aws_security_group_rule" "cice_http_usa" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cice_usa_sg.id

  provider = aws.usa
}

resource "aws_security_group_rule" "cice_egress_usa" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cice_usa_sg.id

  provider = aws.usa
}
