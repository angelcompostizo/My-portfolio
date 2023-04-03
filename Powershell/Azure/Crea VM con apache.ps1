
#crea el grupo de recursos y la localizacion

New-AzResourceGroup -Name "rg-web" -Location 'westeurope'

#crea la maquina virtual que va a instalar el apache
New-AzVm `
    -ResourceGroupName "rg-web"`
    -Name "VMweb"`
    -Location 'westeurope' `
    -Image Debian `
    -size Standard_B2s `
    -PublicIpAddressName myPubIP `
    -OpenPorts 80,22,443 `
    
    #desomentar para generar la ssh key
    #-GenerateSshKey `
    #-SshKeyName mySSHKey

    #esperar a que la maquina este online
    
   
 

#instalar apache en la maquina virtual

$stateVM=  Get-AzVm -Status -ResourceGroupName "rg-web" | Select-object powerstate

#si la maquina esta tiene estado running le pasamos el comando linux para que instale apache

if ($stateVM -eq "running"){

   Invoke-AzVMRunCommand `
   -ResourceGroupName "rg-web"`
   -Name "VMweb"`
   -CommandId 'RunShellScript' `
   -ScriptString 'sudo apt-get update && sudo apt-get install -y apache2'
   
}


   #obtenemos la IP publica de la maquina
   Get-AzPublicIpAddress -Name myPubIP -ResourceGroupName "rg-web" | select "IpAddress"



#  Por ultimo borramos el grupo de reccursos y la maqina.
   Remove-AzResourceGroup -Name "rg-web"
clear