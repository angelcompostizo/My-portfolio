#crea un grupo de recursos llamado "CICE-PS-LINUX"
#CREA UNA VM CON 
#-2VCPUS
#-8GB RAM
#-CENTOS
#-DISCO DE DATOS 20GB
#-ACCESO POR SSH (PUERTO 22) POR IP PUBLICA
#-CREDENCIALES USUARIO-ADMIN1234567

$rg = "CICE-PS-Linux"$location = "westeurope"$user = "ACO" $pass = ConvertTo-SecureString "Admin1234567" -AsPlainText -Force $cred = New-Object System.Management.Automation.PSCredential($user, $pass)  New-AzResourceGroup -ResourceGroupName $rg -Location $locationNew-AzVM -ResourceGroupName $rg `         -Location $location `         -Name "VM1" `         -Size "Standard_D2as_v5" `         -Image "CentOS" `         -DataDiskSizeInGb 20 `         -Credential $cred `         -SecurityGroupName "NSG-VM1" `         -OpenPorts 22 `         -VirtualNetworkName "CICE-VNet" `         -AddressPrefix "10.0.0.0/16" `         -SubnetName "subnet1" `         -SubnetAddressPrefix "10.0.0.0/24" `         -PublicIpAddressName "IP-VM1" `         -OSDiskDeleteOption "Delete" `         -NetworkInterfaceDeleteOption "Delete"
