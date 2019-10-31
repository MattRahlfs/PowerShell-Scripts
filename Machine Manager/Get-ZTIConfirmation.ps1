param(

[Parameter(Mandatory=$true)]
$ComputerName


)


#get hdd space must be more than 10GB
function HDD_test{

if (((Get-PSDrive c | select -ExpandProperty free) / 1GB) -ge 10.0){

return $true

}


}

#scanner check, add to post zti review

#check AD OU "MercyWorkstations" - "Workstations"
function ADOU_test{


if((Get-ADComputer -Identity $ComputerName | where DistinguishedName -Match "OU=Workstations") -or (Get-ADComputer -Identity $ComputerName | where DistinguishedName -Match "OU=MercyWorkstations")){
    return $true}


}

#check subnets
function SN_test{

Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computername -EA Stop | ? {$_.IPEnabled} | select IPSubnet

}

#check encryption?

#speed test - checks if the remote computer can support atleast 5GB an hour
function speed_test{

$Request=Get-Date; Invoke-WebRequest 'http://client.akamai.com/install/test-objects/10MB.bin' | Out-Null;

[int]$speed = (10 / ((NEW-TIMESPAN –Start $Request –End (Get-Date)).totalseconds))

if((($speed * 3600) / 1000) -ge 5.0){

return $true

}


}


HDD_test
ADOU_test
speed_test
