
#creamos tls llave privada
resource "tls_private_key" "cice_key" {
  algorithm = "RSA"
  rsa_bits  = 1024

  provider = tls.private_key
}

#lep asamos el contenido llave
resource "local_file" "cice_pem" {
  filename        = "./cice-tf.pem"
  file_permission = "0400"
  content         = tls_private_key.cice_key.private_key_pem
}

#declaramos el key pair
resource "aws_key_pair" "cice_generated_key" {
  key_name   = "cice-tf"
  public_key = tls_private_key.cice_key.public_key_openssh

  provider = aws.europe
}


#declaramos la instancia con el grupo de recursos.
resource "aws_instance" "cice_europe" {
  ami                    = data.aws_ami.amazon_linux_europe.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.cice_generated_key.key_name
  vpc_security_group_ids = [aws_security_group.cice_europe_sg.id]

  provider = aws.europe

  tags = {
    Name = "CICE Instance"
  }
}

#creamos security groups

resource "aws_security_group" "cice_europe_sg" {
  name        = "CICE SG"
  description = "CICE Security Group created by Terraform"

  provider = aws.europe

  tags = {
    "Name" = "CICE_SG"
  }
}

#creamos security group rules para conexion ssh a las instancias (puerto 22)
resource "aws_security_group_rule" "cice_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cice_europe_sg.id

  provider = aws.europe
}

#creamos el security group para permitir trafico http por el puerto 80
resource "aws_security_group_rule" "cice_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cice_europe_sg.id

  provider = aws.europe
}

#egress rule del  security group
resource "aws_security_group_rule" "cice_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cice_europe_sg.id

  provider = aws.europe
}