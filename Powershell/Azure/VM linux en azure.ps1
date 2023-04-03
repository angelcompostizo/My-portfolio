
# Instala el modulo de powershell si es necesario (requiere permisos de administrador)

#Install-Module -Name Az -AllowClobber

# editamos las variables que vamos a usar

$YOURSUBSCRIPTIONID='4079abbe-ef74-4c5d-81d8-f3d2d297a2db'
$RESOURCEGROUPNAME='RG-Linux'
$REGIONNAME='westeurope'
$PREFIX='Backend'
$LOGINUSERNAME='azlinuxuser'
$LOGINPASSWORD = ConvertTo-SecureString 'Linux123456789' -AsPlainText -Force
$VMNAME='LinuxVM'
$IMAGE='Canonical:UbuntuServer:16.04-LTS:latest'
$VMSIZE='Standard_B1s'
$VMDATADISKSIZEINGB=5

# Conectamos con azure con el comando de abajo
Connect-AzAccount

# conectamos la subscripcion
Set-AzContext `
 -SubscriptionId $YOURSUBSCRIPTIONID

# Creamos el grupo de recursos en al region pasada por las variables
Write-Host Creating resource group named $RESOURCEGROUPNAME in region $REGIONNAME
New-AzResourceGroup `
 -Name $RESOURCEGROUPNAME `
 -Location $REGIONNAME

# Creamos la variable donde almacenamos las credenciales (Login y pass)
$VMCREDENTIALS = New-Object System.Management.Automation.PSCredential ($LOGINUSERNAME, $LOGINPASSWORD);

# Creamos la maquina virtual

Write-Host "Creando la maquina virtual con Nombre: $VMNAME Con tamaño: $VMSIZE y abriendo puertos: 80, 443 y 22, esto tomara algunos minutos..."

#Variables de la VM

New-AzVM `
 -ResourceGroupName $RESOURCEGROUPNAME `
 -Name $VMNAME `
 -Image $IMAGE `
 -Size $VMSIZE `
 -Credential $VMCREDENTIALS `
 -DataDiskSizeInGb $VMDATADISKSIZEINGB `
 -OpenPorts 80,443,22 `

#Obtenemos el estado de la VM

Get-AzVM -Name $vmName -Status

 $VMStats = (Get-AzureRmVM -Name $VMNAME -ResourceGroupName $RESOURCEGROUPNAME -Status).Statuses
($VMStats | Where Code -Like 'PowerState/*')[0].DisplayStatus



# Creamos la IP publica de la VM creada

Get-AzPublicIpAddress -ResourceGroupName $RESOURCEGROUPNAME -Name $VMNAME| Select-Object {$_.IpAddress}



 #Borramos por ultimo el grupo de recursos y la maquina virtual creada

 Get-AzResourceGroup -Name $RESOURCEGROUPNAME | Remove-AzResourceGroup