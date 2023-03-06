data "aws_ami" "amazon_linux_europe" {
  most_recent = true
  owners      = ["amazon"]

  provider = aws.europe

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "amazon_linux_usa" {
  most_recent = true
  owners      = ["amazon"]

  provider = aws.usa

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}