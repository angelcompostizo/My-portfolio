#declarativa de provedores para amazon web services

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.3"
    }
  }
}

#provider aws usa
provider "aws" {
  region = "us-east-1"
  alias  = "usa"
}

#provider aws europa
provider "aws" {
  region = "eu-west-1"
  alias  = "europe"
  default_tags {
    tags = {
      Enviroment = "Develop"
      Owner      = "Chamo"
      Project    = "CICE Máster"
    }
  }
}
#provider tls para llaves privadas (private keys)
provider "tls" {
  alias = "private_key"
}