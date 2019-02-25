param(

$ComputerName

)

Invoke-Command -ComputerName $ComputerName -ScriptBlock {Get-Process -Name "ICUMon*" | Stop-Process -Force}