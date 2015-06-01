#This script will create an Azure VM with 2 network adapters.
#Needs some cleanup still.


$subscriptionName = "changeme"
$hostname = "changeme"
$serviceName = "changeme"
$localAdmin = "changeme"
$localAdminPass = "changeme"
$storageAccount = "changeme"
$primaryNetwork = "changme"
$primaryIP = "changeme"
$primarySubnet = "changeme"
$secondaryInterfaceName = "changeme"
$secondaryIP = "changeme"
$secondarySubnet = "changeme"
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccountName $storageAccount

#  I should probably seperate this into 2 different scripts but for now just uncomment/comment
####  BEGIN MARKET PLACE IMAGE
####  Uncomment this section for a Marketplace image, leave commented to use an existing disk
#$imageName = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201504.01-en.us-127GB.vhd"
#$imageName = @( Get-AzureVMImage | where-object{$_.ImageName -like "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201504.01-en.us-127GB.vhd"}).ImageName
#$image = Get-AzureVMImage -ImageName $imageName
#$vm = New-AzureVMConfig -Name $hostname -InstanceSize "Large" -Image $image.ImageName -AvailabilitySetName $hostname
#Add-AzureProvisioningConfig -VM $vm -Windows -AdminUserName $localadmin -Password $localadminpass
####  END MARKET PLACE IMAGE

####  BEGIN EXISTING DISK
####  Uncomment this section to use existing disk, comment it out to use a Market place image
$diskName = "DEVASSISTVS2013UPD4-VS2013UPD4-0-201505271657420497"
$vm = New-AzureVMConfig -Name $hostname -InstanceSize "Large" -DiskName $diskName -AvailabilitySetName $hostname
####  END EXISTING DISK

Set-AzureSubnet -SubnetNames $primarySubnet -VM $vm
Set-AzureStaticVNetIP -IPAddress $primaryIP -VM $vm
Add-AzureNetworkInterfaceConfig -Name $secondaryInterfaceName -SubnetName $secondarySubnet -StaticVNetIPAddress $secondaryIP -VM $vm
New-AzureVM -ServiceName $serviceName -VNetName $primaryNetwork -VM $vm
