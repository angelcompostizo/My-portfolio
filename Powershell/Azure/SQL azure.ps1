
#connect to your az account tenant
#Connect-AzAccount


# The SubscriptionId in which to create all database

$SubscriptionId = "XXXXXXXXXXXXXX"

# Set the resource group name and location for your server
$resourceGroupName = "rg-mysql"
$location = "westeurope"


# Set an administrator login and password for your  MySQL server
$adminSqlLogin = "Sqladmin"
$password = "Sqlogin1134"


# Set server name - WARNING!! the logical server name has to be unique in the system

$serverName = "server-$(Get-Random)"

# The sample database name
$databaseName = "mysqldbsample"

# The ip address range that you want to allow to access your db server 
#(note: you can use: hostname -i / ifconfig command to retrieve IP values on Linux Sistems 
# Windows powershell could use Get-NetIPAddress | Select-Object IPAddress)

$startIp = "127.0.1.1"
$endIp = "255.255.0.0"

# Set subscription wich will operate on azure
Set-AzContext -SubscriptionId $subscriptionId 

# Create a resource group who store the MySQL DB

$resourceGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a server with a system wide unique server name (MySQL server db) admin credentials

$server = New-AzSqlServer -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -Location $location `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminSqlLogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

# Create a server firewall rule that allows access from the specified IP range to restrict unwanted connections to our db

$serverFirewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -FirewallRuleName "AllowedIPs" -StartIpAddress $startIp -EndIpAddress $endIp

# Create a blank database with an S0 performance level
$database = New-AzSqlDatabase  -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -DatabaseName $databaseName `
    -RequestedServiceObjectiveName "S0" `
    -SampleName "AdventureWorksLT"




# Clean up deployment after use
 Remove-AzResourceGroup -ResourceGroupName $resourceGroupName