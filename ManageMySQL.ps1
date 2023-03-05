

#Variables to get report to date
$ReportDate = (Get-Date).ToString("yyyy-MM-dd HH:mm")

#Login to Azure
#Connect-AzAccount
 
#Select Azure Subscription by name
$SubscriptionId = "d99735d0-f5d8-45c3-a97a-53c4027f9532"
$SubscriptionName= (Get-AzContext).Subscription.Name

#the subscription where the database is running
$SubscriptionId = "d99735d0-f5d8-45c3-a97a-53c4027f9532"


#Collect Data about SQL servers

#creates a blank array to get the inventory
$AzureSQLBackupInventory = @()
$AzureSQLServers = Get-AzResource  | Where-Object ResourceType -EQ Microsoft.SQL/servers

#Goes throught a list of SQL servers and retains data passing througt resource group name filtering by database objects

foreach ($AzureSQLServer in $AzureSQLServers){
    $AzureSQLServerDataBases = Get-AzSqlDatabase -ServerName $AzureSQLServer.Name -ResourceGroupName $AzureSQLServer.ResourceGroupName | Where-Object DatabaseName -NE "master"
        foreach ($AzureSQLServerDataBase in $AzureSQLServerDataBases) {
            $DBLevelInventory =  @()
            $BackupState = Get-AzSqlDatabaseGeoBackupPolicy  -ServerName $($AzureSQLServerDataBase.ServerName) -DatabaseName $($AzureSQLServerDataBase.DatabaseName) -ResourceGroupName $($AzureSQLServerDataBase.ResourceGroupName) | Select-Object -ExpandProperty State

            $DBLevelInventory = New-Object -TypeName psobject
                $DBLevelInventory | Add-Member -MemberType NoteProperty -Name "Subscription Name" -Value $SubscriptionName
                $DBLevelInventory | Add-Member -MemberType NoteProperty -Name "Resource Group" -Value $AzureSQLServerDataBase.ResourceGroupName
                $DBLevelInventory | Add-Member -MemberType NoteProperty -Name "SQL Server Name" -Value $AzureSQLServerDataBase.ServerName
                $DBLevelInventory | Add-Member -MemberType NoteProperty -Name "DataBase Name" -Value $AzureSQLServerDataBase.DatabaseName
                $DBLevelInventory | Add-Member -MemberType NoteProperty -Name "Creation Date" -Value $AzureSQLServerDataBase.CreationDate 
                $AzureSQLBackupInventory+=$DBLevelInventory
                        
        }
}

#export data to an excel
#--------------------------------------------------------------------------
# Build File and Output to Path of your choice
$dateString = $ReportDate
$filePath = "/home/usuario/reports"
$fileName = ("Azure-SQL_Report_" + $SubscriptionName + "_" + $dateString + ".html")
$outFile = $filePath + $fileName
#--------------------------------------------------------------------------

#