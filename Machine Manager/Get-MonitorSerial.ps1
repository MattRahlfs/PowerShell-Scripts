
param(

[string[]]$Computers,

[String[]]$IPAddress,

[string]$Path

)



If($Computers -ne $null){

foreach ($machine in $Computers){

If(Test-Connection -ComputerName $machine -Count 1 -ErrorAction SilentlyContinue){

$out = Invoke-Command -ComputerName $machine -ScriptBlock {


$Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi

ForEach ($Monitor in $Monitors){
	
	$Name = ($Monitor.UserFriendlyName -notmatch 0 | ForEach{[char]$_}) -join ""
	$Serial = ($Monitor.SerialNumberID -notmatch 0 | ForEach{[char]$_}) -join ""
    
   return "$env:COMPUTERNAME, $Name, $Serial"
    
}


} 

Write-Output "Scanned machine: $machine`n"
$out

 }
 Else{Write-Host "Failed to connect to $machine"}
}
}
ElseIf($IPADdress -ne $null){

    foreach ($machine in $IPAddress){


Try {
    $hostname = [System.Net.Dns]::GetHostByAddress("$machine").Hostname
    
    If(Test-Connection -ComputerName $hostname -Count 1 -ErrorAction Stop){

Try {

$out = Invoke-Command -ComputerName $hostname -ScriptBlock{


$Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi

ForEach ($Monitor in $Monitors){
	
	$Name = ($Monitor.UserFriendlyName -notmatch 0 | ForEach{[char]$_}) -join ""
	$Serial = ($Monitor.SerialNumberID -notmatch 0 | ForEach{[char]$_}) -join ""
    
   return "$env:COMPUTERNAME, $Name, $Serial"
    
}


} 
Write-Host "Scanned: $machine - $hostname"

}
Catch {write-host "Failed to Invoke on $machine"}


 
$out | Out-File "$path" -Append


 }
 Else{Write-Host "Failed to connect to $machine"}}
Catch {Write-Host "Unable to retrive the workstation name from $machine"}

 
}

}

