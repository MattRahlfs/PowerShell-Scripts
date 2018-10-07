param (

$ComputerName

)


if (& "$psscriptroot\itmo.ps1" $ComputerName){

Try {

if(Get-Service -ComputerName $ComputerName -DisplayName "*isirona*" -ErrorAction Stop){

Write-Host -ForegroundColor Green "Here are the current running services related to `"isirona`" on $ComputerName`n"

Get-Service -ComputerName $ComputerName -DisplayName "*isirona*" -ErrorAction Stop

Write-Host -ForegroundColor Green "`nStopping `"isirona DeviceEscort Service`" and `"isirona DeviceConX Service`""

Invoke-Command -ComputerName $ComputerName {Stop-Service -DisplayName "isirona DeviceEscort Service", "isirona DeviceConX Service" -Force}

Write-Host -ForegroundColor Green "The Services should be stopped now`n"

Get-Service -ComputerName $ComputerName -DisplayName "*isirona*" -ErrorAction Stop

start-sleep -Seconds 5

Write-Host -ForegroundColor Green "`nStarting the services again`n"

Invoke-Command -ComputerName $ComputerName {Start-Service -DisplayName "isirona DeviceEscort Service", "isirona DeviceConX Service"}

Get-Service -ComputerName $ComputerName -DisplayName "*isirona*" -ErrorAction Stop

}
else{Write-Host -ForegroundColor Red "The Isirona Services do not exist on $ComputerName"}




}
Catch{Write-Host -ForegroundColor Red "Failed to get services from $ComputerName"}

}
