#This script is used to set the MAC address, IP, and DNS settings for a network adapter
#This is needed for an Azure machine to run EMC ApplicationXtender license server which requires a static mac address but Azure doesn't allow for this
#I use a seperate Network adapter in the Azure hosted machine and use this script to manually set the Mac address on boot
#Note that you change the mac address of the primary network adapter through which you are connect, you will loose access to the machine permanently.
#So be sure to only perform this action on a second network adapter that is not needed for communication

$mac = "00155DD279F3"  #Mac Address the license server needs to startup
$ip = "10.1.0.36"    #Static IP set in Azure (once we change the Mac the machine will no longer get an address from dhcp so we will use this to find the correct nic and then set it to static IP"
$dns = "10.0.0.10"   #Since we no longer have DHCP we need to specify the DNS server

#Set Mac
$LicenseServerNic = Get-NetIPAddress | WHERE {$_.IPAddress -eq $ip}
Set-NetAdapter -Name $LicenseServerNic.InterfaceAlias -MacAddress $mac

#Set Static IP
Set-NetIPAddress -InterfaceAlias $LicenseServerNic.InterfaceAlias -IPAddress $ip -AddressFamily IPv4 -PrefixLength 27

#Set DNS
Set-DnsClientServerAddress -InterfaceAlias $LicenseServerNic.InterfaceAlias -ServerAddresses $dns
