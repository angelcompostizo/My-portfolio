
# fichero main donde declararemos los providers antes de incializar

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

#configuramos el aws provider para la practica

provider "aws" {
  region = "eu-west-1"
 
  


#declaramos los tags
  default_tags {
    tags = {
      
      Application = "static website"
      Owner      = "aco"
    
    }
  }
}

#creamos el modulo del website
module "staticwebsite" {
  source = "./../staticwebsite"
  bucketname = "acowebsitebucket"
  
}