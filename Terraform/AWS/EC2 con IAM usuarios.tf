# Definicion de provider
provider "aws" {
  region = "eu-west-1"
  
}

# Creamos un usuario IAM y su grupo para acceder al EC2

#grupo ec2
resource "aws_iam_group" "ec2_access" {
  name = "ec2_access"
}

#usuario iam del ec2
resource "aws_iam_user" "ec2_user" {
  name = "ec2_user"
}

#declaramos la membresia del iam del usuario para ec2 declarado
resource "aws_iam_group_membership" "ec2_access_membership" {
  name  = aws_iam_group.ec2_access.name
  users = [
    aws_iam_user.ec2_user.name,
  ]
}

# Creamos la politica de IAM para el acceso
resource "aws_iam_policy" "ec2_access_policy" {
  name        = "ec2_access_policy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# atachamos la politica al grupo ec2
resource "aws_iam_group_policy_attachment" "ec2_access_attachment" {
  policy_arn = aws_iam_policy.ec2_access_policy.arn
  group      = aws_iam_group.ec2_access.name
}

# Creamos el NSG para la instancia ec2, habilitamos puerto 22
resource "aws_security_group" "linux_sg" {
  name_prefix = "linux_sg_"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creamos la instancia EC2 (linux) con su keypair (mykeypair)
resource "aws_instance" "linux_instance" {
  ami           = "ami-04763b3055de4860b"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0b5dc364"
  key_name      = "mykeypair"
  vpc_security_group_ids = [
    aws_security_group.linux_sg.id,
  ]
  tags = {
    Name = "Linux Instance"
  }
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
}

# Asignamos el ROL IAM a la instancia EC2

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

#le pasamos la politica del rol en JSON
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

#invocacion de recursos de politica y rol
resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  policy_arn = aws_iam_policy.ec2_access_policy.arn
  role       = aws_iam_role.ec2_role.name
}
