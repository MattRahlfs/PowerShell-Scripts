
param(

$ComputerName

)


Try{

If (& "$PSScriptRoot\Get-MachineConnection.ps1" $ComputerName){

Invoke-Command -ComputerName $ComputerName -ScriptBlock {Get-Process | Select ProcessName, ID, Description, Path, Product, Company | Format-Table}

}
Else{Write-Output "Unable to connect to the machine"}


}
Catch {Write-Output "An error occured"}
