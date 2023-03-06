resource "aws_iam_user" "cice_user_aws" {
  name     = "cice_terraform"
  provider = aws.europe

  tags = {
    "Name"        = "cice_terraform"
    "Descripción" = "Usuario de prueba desde terraform"
  }
}
