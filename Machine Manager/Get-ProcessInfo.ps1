
param(

$ComputerName

)


Try{

If (& "$PSScriptRoot\itmo.ps1" $ComputerName){

Invoke-Command -ComputerName $ComputerName -scriptblock {Get-Process | Select ProcessName, ID, Description, Path, Product, Company | Format-List}

}
Else{Write-Output "Unable to connect to the machine"}


}
Catch {Write-Output "An error occured"}
