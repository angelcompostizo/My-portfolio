# Configuramos el provedor de azure en caso de no tenerlo
provider "azurerm" {
  features {}
}

# Creamos el grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "mySql-resource-group"
  location = "eastus"
}

# Creamos la virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "mySql-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Creamos la subnet para la instnacia mysql
resource "azurerm_subnet" "subnet" {
  name                 = "mysql-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Creamos la instnacia MySQL
resource "azurerm_mysql_server" "mysql" {
  name                = "mySql-mysql-server"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "GP_Gen5_2"

#añadimos el storage profile en MB y politica de retencion de 7 dias
  storage_profile {
    storage_mb         = 51200
    backup_retention_days = 7
  }

#credenciales del a BBDD login/pass

  administrator_login          = "mysqladmin"
  administrator_login_password = "Password1234!"
  version                      = "5.7"
  ssl_enforcement_enabled      = true

  auto_grow_enabled = true

#le pasamos la configuracion de subnet 
  network_configuration {
    subnet_id = azurerm_subnet.subnet.id
  }
}

# Creamos la regla del firewall para poder acceder al servidor mysql
resource "azurerm_mysql_firewall_rule" "mysql_firewall_rule" {
  name                = "mySql-mysql-firewall-rule"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

# sacamos el output del string de conexion de mySQL
output "mysql_connection_string" {
  value = "Server=${azurerm_mysql_server.mysql.fqdn};Port=3306;Database=mydatabase;User ID=mysqluser@${azurerm_mysql_server.mysql.name};Password=Password1234!;SslMode=Preferred;"
}
