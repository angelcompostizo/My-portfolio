
#create the new resource group for our web server.

New-AzResourceGroup -Name "rg-web" -Location 'westeurope'

#create the VM to install apache web server
New-AzVm `
    -ResourceGroupName "rg-web"`
    -Name "VMweb"`
    -Location 'westeurope' `
    -Image Debian `
    -size Standard_B2s `
    -PublicIpAddressName myPubIP `
    -OpenPorts 80,22,443 `
    
    #-GenerateSshKey `
    #-SshKeyName mySSHKey

    #Check the VM is Online status
    
   
 

#install apache web server in the vm created if status is Running

$stateVM=  Get-AzVm -Status -ResourceGroupName "rg-web" | Select-object powerstate


if ($stateVM -eq "running"){

   Invoke-AzVMRunCommand `
   -ResourceGroupName "rg-web"`
   -Name "VMweb"`
   -CommandId 'RunShellScript' `
   -ScriptString 'sudo apt-get update && sudo apt-get install -y apache2'
   
}


   #Get the public adress of the VM to see web server running
   Get-AzPublicIpAddress -Name myPubIP -ResourceGroupName "rg-web" | select "IpAddress"



#  delete the resource group
   Remove-AzResourceGroup -Name "rg-web"
clear