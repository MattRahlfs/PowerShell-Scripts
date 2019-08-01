param(


$_ComputerName

)




Invoke-Command -ComputerName $_ComputerName  -ArgumentList $_ComputerName -ScriptBlock {

param (

$_ComputerName

)

Get-ChildItem -Path \\$_ComputerName\C$\users\ | select name, lastwritetime | Format-List



}



