
 

#****Script para destruir una VM creada ****

$resourceGroupName = Read-Host -Prompt "Enter the Resource Group name to destroy"
$VMtoDestroy = Get-AzVm -Name -ResourceGroupName $resourceGroupName

#borra el boot diagnosis parseando la Url.property de almacenamiento que esta en el diagnosis profile de la VM
$diagSa = [regex]::match($vm.DiagnosticsProfile.bootDiagnostics.storageUri, '^http[s]?://(.+?)\\.').groups[1].value

#Obtiene el nombre del boot diagnosis container para borrarlo

if ($vm.Name.Length -gt 9) {
    $i = 9
} else {
    $i = $vm.Name.Length - 1
}

$azResourceParams = @{
    'ResourceName' = WINSRV
    'ResourceType' = 'Microsoft.Compute/virtualMachines'
    'ResourceGroupName' = $resourceGroupName
}

$vmResource = Get-AzResource @azResourceParams
$vmId = $vmResource.Properties.VmId
$diagContainerName = ('bootdiagnostics-{0}-{1}' -f $vm.Name.ToLower().Substring(0, $i), $vmId)

#obtiene el nombre del RG del contenedor del boot container 

$diagSaRg = (Get-AzStorageAccount | where { $_.StorageAccountName -eq $diagSa }).ResourceGroupName

#tras pasar la variable del RG podemos borrarlo

$diagSaRg = (Get-AzStorageAccount | where { $_.StorageAccountName -eq $diagSa }).ResourceGroupName

#Borra la maquina virtual con FORCE

$null = $vm | Remove-AzVM -Force

#borra la NIC y la direccion IP publica

foreach($nicUri in $vm.NetworkProfile.NetworkInterfaces.Id) {
    $nic = Get-AzNetworkInterface -ResourceGroupName $vm.ResourceGroupName -Name $nicUri.Split('/')[-1]
    Remove-AzNetworkInterface -Name $nic.Name -ResourceGroupName $vm.ResourceGroupName -Force

    foreach($ipConfig in $nic.IpConfigurations) {
        if($ipConfig.PublicIpAddress -ne $null) {
            Remove-AzPublicIpAddress -ResourceGroupName $vm.ResourceGroupName -Name $ipConfig.PublicIpAddress.Id.Split('/')[-1] -Force
        }
    }
}

#Borra discos del S.O

$osDiskUri = $vm.StorageProfile.OSDisk.Vhd.Uri
$osDiskContainerName = $osDiskUri.Split('/')[-2]
$osDiskStorageAcct = Get-AzStorageAccount | where { $_.StorageAccountName -eq $osDiskUri.Split('/')[2].Split('.')[0] }
$osDiskStorageAcct | Remove-AzStorageBlob -Container $osDiskContainerName -Blob $osDiskUri.Split('/')[-1]

#Borra blobs del S.O

$osDiskStorageAcct | Get-AzStorageBlob -Container $osDiskContainerName -Blob "$($vm.Name)*.status" | Remove-AzStorageBlob

#Borra discos attached del S.O

if ($vm.DataDiskNames.Count -gt 0) {
    foreach ($uri in $vm.StorageProfile.DataDisks.Vhd.Uri) {
        $dataDiskStorageAcct = Get-AzStorageAccount -Name $uri.Split('/')[2].Split('.')[0]
        $dataDiskStorageAcct | Remove-AzStorageBlob -Container $uri.Split('/')[-2] -Blob $uri.Split('/')[-1]
    }
}