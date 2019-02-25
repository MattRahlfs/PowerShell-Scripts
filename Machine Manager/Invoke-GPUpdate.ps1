param(

$_computerName



)



Invoke-Command -ComputerName $_computerName -ScriptBlock {


gpupdate.exe /force




}