
#creamos el grupo de recursos

resource   "azurerm_resource_group"   "rg"   {
  name   =   "Linux-terraform"
  location   =   "westeurope"
}

#creamos el NSG de terraform y las reglas de seguridad
resource "azurerm_network_security_group" "linuxnsg" {
    name                = "myNetworkSecurityGroup"
    location            = "west-EU"
    resource_group_name = azurerm_resource_group.linuxgroup.name

#abrimos el puerto 22 para permitir SSH
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

#creamos la vnet y la subnet

resource   "azurerm_virtual_network"   "myvnet"   {
  name   =   "my-vnet"
  address_space   =   [ "10.0.0.0/16" ]
  location   =   "westeurope"
  resource_group_name   =   azurerm_resource_group.rg.name
}

resource   "azurerm_subnet"   "linuxsubnet"   {
  name   =   "linuxsubnet"
  resource_group_name   =    azurerm_resource_group.rg.name
  virtual_network_name   =   azurerm_virtual_network.myvnet.name
  address_prefix   =   "10.0.1.0/24"
}

#definimos la IP publica

resource   "azurerm_public_ip"   "azurevm1publicip"   {
  name   =   "pip1"
  location   =   "westeurope"
  resource_group_name   =   azurerm_resource_group.rg.name
  allocation_method   =   "Dynamic"
  sku   =   "Basic"
}

#definimos la NIC

resource   "azurerm_network_interface"   "azurevm1nic"   {
  name   =   "azurevm1-nic"
  location   =   "westeurope"
  resource_group_name   =   azurerm_resource_group.rg.name

  ip_configuration   {
    name   =   "ipconfig1"
    subnet_id   =   azurerm_subnet.linuxsubnet.id
    private_ip_address_allocation   =   "Dynamic"
    public_ip_address_id   =   azurerm_public_ip.myvm 1 publicip.id
  }
}

#definimos la instancia linux VM

resource   "azurerm_linux_virtual_machine"   "linuxvm"   {
  name                    =   "azurevm1"
  location                =   "westeurope"
  resource_group_name     =   azurerm_resource_group.rg.name
  network_interface_ids   =   [ azurerm_network_interface.myvm 1 nic.id ]
  size                    =   "Standard_B1s"
  computer_name           =   "linuxvm"
  admin_username          =   "hiteshj"
  admin_password          =   "securepassword!"

  source_image_reference   {
       publisher = "Canonical"
       offer     = "UbuntuServer"
       sku       = "20.04-LTS"
       version   = "latest"
  }

  os_disk   {
    caching             =   "ReadWrite"
    storage_account_type   = "Standard_LRS"
  }
}

#creamos objeto para mostrar el output del valor y la IP publica

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.linuxvm.public_ip_address
}