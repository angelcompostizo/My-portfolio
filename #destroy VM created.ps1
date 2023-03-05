#destroy VM created

$resourceGroupName = Read-Host -Prompt "Enter the Resource Group name to destroy"
$VMtoDestroy = Get-AzVm -Name -ResourceGroupName $resourceGroupName

#Remove Boot diagnosis Storage account  parsing of the storageUri property that’s buried in the DiagnosticsProfile VM 

$diagSa = [regex]::match($vm.DiagnosticsProfile.bootDiagnostics.storageUri, '^http[s]?://(.+?)\\.').groups[1].value

#get then name of the boot diagnostics container to delete

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

#get the rs name boot container is part of 

$diagSaRg = (Get-AzStorageAccount | where { $_.StorageAccountName -eq $diagSa }).ResourceGroupName

#finally remove storage container 

$diagSaRg = (Get-AzStorageAccount | where { $_.StorageAccountName -eq $diagSa }).ResourceGroupName

#remove VM 

$null = $vm | Remove-AzVM -Force

#remove network interface and public adress

foreach($nicUri in $vm.NetworkProfile.NetworkInterfaces.Id) {
    $nic = Get-AzNetworkInterface -ResourceGroupName $vm.ResourceGroupName -Name $nicUri.Split('/')[-1]
    Remove-AzNetworkInterface -Name $nic.Name -ResourceGroupName $vm.ResourceGroupName -Force

    foreach($ipConfig in $nic.IpConfigurations) {
        if($ipConfig.PublicIpAddress -ne $null) {
            Remove-AzPublicIpAddress -ResourceGroupName $vm.ResourceGroupName -Name $ipConfig.PublicIpAddress.Id.Split('/')[-1] -Force
        }
    }
}

#removing os disks

$osDiskUri = $vm.StorageProfile.OSDisk.Vhd.Uri
$osDiskContainerName = $osDiskUri.Split('/')[-2]
$osDiskStorageAcct = Get-AzStorageAccount | where { $_.StorageAccountName -eq $osDiskUri.Split('/')[2].Split('.')[0] }
$osDiskStorageAcct | Remove-AzStorageBlob -Container $osDiskContainerName -Blob $osDiskUri.Split('/')[-1]

#removing OS disk blobs

$osDiskStorageAcct | Get-AzStorageBlob -Container $osDiskContainerName -Blob "$($vm.Name)*.status" | Remove-AzStorageBlob

#removed attached disk OS

if ($vm.DataDiskNames.Count -gt 0) {
    foreach ($uri in $vm.StorageProfile.DataDisks.Vhd.Uri) {
        $dataDiskStorageAcct = Get-AzStorageAccount -Name $uri.Split('/')[2].Split('.')[0]
        $dataDiskStorageAcct | Remove-AzStorageBlob -Container $uri.Split('/')[-2] -Blob $uri.Split('/')[-1]
    }
}