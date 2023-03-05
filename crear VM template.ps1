#Login to your Azure account.
#Login-AzAccount
#Define the following parameters for the virtual machine.
$vmAdminUsername = "ACO"
$vmAdminPassword = ConvertTo-SecureString "Admin1234" -AsPlainText -Force
$vmComputerName = "SRV-SQL02"
#Define the following parameters for the Azure resources.
$azureLocation              = "West Europe"
$azureResourceGroup         = "BSDomain-RG"
$azureVmName                = "SRV-SQL02"
$azureVmOsDiskName          = "SRV-SQL02-OS"
$azureVmSize                = "Standard_E4s_v3"
#Define the networking information.
$azureNicName               = "SRV-SQL02-NIC"
$azurePublicIpName          = "SRV-SQL02-IP"
#Define the existing VNet information.
$azureVnetName              = "SRV-Vnet"
$azureVnetSubnetName        = "default"
#Define the VM marketplace image details.
$azureVmPublisherName = "MicrosoftWindowsServer"
$azureVmOffer = "WindowsServer"
$azureVmSkus = "2019-Datacenter"
#Get the subnet details for the specified virtual network + subnet combination.
$azureVnetSubnet = (Get-AzVirtualNetwork -Name $azureVnetName -ResourceGroupName $azureResourceGroup).Subnets | Where-Object {$_.Name -eq $azureVnetSubnetName}
#Create the public IP address.
$azurePublicIp = New-AzPublicIpAddress -Name $azurePublicIpName -ResourceGroupName $azureResourceGroup -Location $azureLocation -AllocationMethod Dynamic
#Create the NIC and associate the public IpAddress.
$azureNIC = New-AzNetworkInterface -Name $azureNicName -ResourceGroupName $azureResourceGroup -Location $azureLocation -SubnetId $azureVnetSubnet.Id -PublicIpAddressId $azurePublicIp.Id
#Store the credentials for the local admin account.
$vmCredential = New-Object System.Management.Automation.PSCredential ($vmAdminUsername, $vmAdminPassword)
#Define the parameters for the new virtual machine.
$VirtualMachine = New-AzVMConfig -VMName $azureVmName -VMSize $azureVmSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $vmComputerName -Credential $vmCredential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $azureNIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName $azureVmPublisherName -Offer $azureVmOffer -Skus $azureVmSkus -Version "latest"
$VirtualMachine = Set-AzVMBootDiagnostic -VM $VirtualMachine -Disable
$VirtualMachine = Set-AzVMOSDisk -VM $VirtualMachine -StorageAccountType "Premium_LRS" -Caching ReadWrite -Name $azureVmOsDiskName -CreateOption FromImage
#Create the virtual machine.

#New-AzResourceGroup -Name $azureResourceGroup -Location $azureLocation
New-AzVM -ResourceGroupName $azureResourceGroup -Location $azureLocation -VM $VirtualMachine -Verbose