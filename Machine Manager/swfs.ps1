
[cmdletbinding()]
param (

[string[]]$devices,

$path,

[switch]$C

)


function devices{

$serialNum = ($serialNum = -split $devices).Substring(1)

$object = New-Object -TypeName psobject

Write-Host -ForegroundColor Green "`n*******`n"
$serialNum
Write-Host -ForegroundColor Green "`n*******"

}



function path {

$devicesinpath = Get-Content -Path $path
Write-Host -ForegroundColor Green "`n*******`n"

foreach ($name in $devicesinpath)
{
$serialNum = ($serialNum = -split $name).Substring(1)


$serialNum

}

Write-Host -ForegroundColor Green "`n*******"


}



function clipboard{


$serialNum = ($serialNum = -split (Get-Clipboard)).Substring(1)

Write-Host -ForegroundColor Green "`n*******`n"
$serialNum
Write-Host -ForegroundColor Green "`n*******"

Set-Clipboard $serialNum


}




if ($C -ne $false){

clipboard


}
ElseIf($path -ne $null){

path

}
ElseIf($devices -ne $null){

devices

}


