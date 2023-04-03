terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.37.0"
    }
  }
}

# Configurar el Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "<Your-Subscription Id>"
  tenant_id       = "<Your-Tenant-Id>"
  client_id       = "<Your-Client-Id>"
  client_secret   = "<Your-Client-Secret>"
}