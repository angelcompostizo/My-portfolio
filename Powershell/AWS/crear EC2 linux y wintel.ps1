
$ACCESS_KEY= "dsfsdfdsf"
$SECRET_KEY= "tu secret key"
$REGION= "eu-west-1"
$MyKeyPair= "tu keypair"


# define las credenciales de aws
Set-AWSCredentials -AccessKey $ACCESS_KEY -SecretKey $SECRET_KEY -Region $REGION

# Crea una nueva VPC
$vpc = New-EC2Vpc -CidrBlock "10.0.0.0/16" -InstanceTenancy "default"

# Crea una snuevsa subnet en la VPC
$subnet = New-EC2Subnet -VpcId $vpc.VpcId -CidrBlock "10.0.1.0/24"

# Crea un internet gateway para acceder a la VPC
$gateway = New-EC2InternetGateway

# Une la VPC al IGW
Add-EC2InternetGateway -InternetGatewayId $gateway.InternetGatewayId -VpcId $vpc.VpcId

# Crea la route table de la VPC
$routeTable = New-EC2RouteTable -VpcId $vpc.VpcId

# Crea route table del IGW
Add-EC2Route -RouteTableId $routeTable.RouteTableId -DestinationCidrBlock "0.0.0.0/0" -GatewayId $gateway.InternetGatewayId

# Asocia la route table con la subnet del ec2
Associate-EC2RouteTable -RouteTableId $routeTable.RouteTableId -SubnetId $subnet.SubnetId

# Crea un NSG para instancia windows
$windowsSecurityGroup = New-EC2SecurityGroup -VpcId $vpc.VpcId -GroupName "WindowsSecurityGroup" -Description "Security group for Windows instance"
$windowsSecurityGroup | Add-EC2SecurityGroupIngress -IpProtocol tcp -FromPort 3389 -ToPort 3389 -CidrIp "0.0.0.0/0"

# Lanza la instancia windows
$windowsInstance = New-EC2Instance -ImageId "ami-0323c3dd2da7fb37d" -InstanceType "t2.micro" -KeyName "MyKeyPair" -SecurityGroupId $windowsSecurityGroup.GroupId -SubnetId $subnet.SubnetId

# Crea NSG para instancia Linux
$linuxSecurityGroup = New-EC2SecurityGroup -VpcId $vpc.VpcId -GroupName "LinuxSecurityGroup" -Description "Security group for Linux instance"
$linuxSecurityGroup | Add-EC2SecurityGroupIngress -IpProtocol tcp -FromPort 22 -ToPort 22 -CidrIp "0.0.0.0/0"

# Lanza la instancia Linux
$linuxInstance = New-EC2Instance -ImageId "ami-0c55b159cbfafe1f0" -InstanceType "t2.micro" -KeyName "MyKeyPair" -SecurityGroupId $linuxSecurityGroup.GroupId -SubnetId $subnet.SubnetId
