


#declaramos providers

provider "aws" {
  region = "us-east-1"
  alias="usa"
}

# Creamos una VPC
resource "aws_vpc" "vpc_ejemplo" {
  cidr_block = "10.0.0.0/16"
}

# Creamos el Internet Gateway
resource "aws_internet_gateway" "vpc_ejemplo" {
  vpc_id = aws_vpc.vpc_ejemplo.id
}

# Attach el internet gatewey al VPC
resource "aws_vpc_attachment" "vpc_ejemplo" {
  vpc_id             = aws_vpc.vpc_ejemplo.id
  internet_gateway_id = aws_internet_gateway.vpc_ejemplo.id
}

# Creamos las subnets necesarias para cada instancia
resource "aws_subnet" "mysql" {
  vpc_id     = aws_vpc.vpc_ejemplo.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "wintel" {
  vpc_id     = aws_vpc.vpc_ejemplo.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "linux" {
  vpc_id     = aws_vpc.vpc_ejemplo.id
  cidr_block = "10.0.3.0/24"
}

# Creamos el NSG para la instancia MySQL
resource "aws_security_group" "mysql" {
  name_prefix = "mysql"
  vpc_id      = aws_vpc.vpc_ejemplo.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creamos el NSG para la instancia Wintel
resource "aws_security_group" "wintel" {
  name_prefix = "wintel"
  vpc_id      = aws_vpc.vpc_ejemplo.id

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creamos el Network Security Group para La instancia Linux
resource "aws_security_group" "linux" {
  name_prefix = "linux"
  vpc_id      = aws_vpc.vpc_ejemplo.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creamos la instancia MySQL
resource "aws_instance" "mysql" {
  ami           = "ami-0323c3dd2da7fb37d" # Imagen amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mysql.id
  security_groups = [aws_security_group.mysql.id]

  tags = {
    Name = "mysql-instance"
  }

# bash script forzando a la instalacion y arranque de mysql sever.
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y mysql-server
              systemctl start mysqld
              EOF
}

# Creamosl a instancia Wintel
resource "aws_instance" "wintel" {
  ami           = "ami-08c1f3a3c5d5a5a5e" # Imagen Windows Server 2019
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.wintel.id
  security_groups = [aws_security_group.wintel.id]

  tags = {
   Name = "wintel-instance"
  }

# ponemos reglas de firewall en la ma
  user_data = <<-EOF
              <powershell>
              Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
              EOF

}


            