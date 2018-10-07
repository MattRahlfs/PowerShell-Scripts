
param (

[string[]]$devices,

$path

)


If($devices -ne $null){

Write-Host -ForegroundColor Green "`n*******`n"
foreach ($ComputerName in $devices){
$WorkstationName =  $ComputerName + ","


$WorkstationName


}
Write-Host -ForegroundColor Green "`n*******"

}
ElseIf($path -ne $null){

$Objects = Get-Content -Path $path

Write-Host -ForegroundColor Green "`n*******`n"
foreach ($Singleobject in $Objects){

$singleobject = $Singleobject.trim()

$singleobject + ","


}
Write-Host -ForegroundColor Green "`n*******"


}