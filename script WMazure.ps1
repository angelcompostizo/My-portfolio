$location = "westeurope"New-AzResourceGroup -ResourceGroupName "CICE-Powershell" -Location $location$user = "rmoro"$pass = ConvertTo-SecureString "Admin1234567" -AsPlainText -Force$cred = New-Object System.Management.Automation.PSCredential($user, $pass)New-AzVM -ResourceGroupName "CICE-Powershell" `         -Location $location `         -Name "VM1" `         -Size "Standard_D2as_v5" `         -Image "Win2019Datacenter" `         -Credential $cred `         -SecurityGroupName "NSG-VM1" `         -OpenPorts 80,3389 `         -VirtualNetworkName "CICE-VNet" `         -AddressPrefix "10.0.0.0/16" `         -SubnetName "subnet1" `         -SubnetAddressPrefix "10.0.0.0/24" `         -PublicIpAddressName "IP-VM1" `         -OSDiskDeleteOption "Delete" `         -NetworkInterfaceDeleteOption "Delete"





#Publisher - MicrosoftwindowsServer
#offer - WindowsServer
#SKU - 2019-Datacenter

