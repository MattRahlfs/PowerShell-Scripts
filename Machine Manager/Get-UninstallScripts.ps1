Param (
[Parameter(Mandatory=$true)]
[string[]]$ComputerName,

[switch]$List,

[switch]$Uninstall

)



$ScriptPath = "C:\Windows\ccmcache"


function getScripts {


Invoke-Command -ComputerName $ComputerName -ArgumentList $ScriptPath -ScriptBlock {

param($ScriptPath)

 $array = @(Get-ChildItem -Path $ScriptPath -Filter "Uni-*" -Recurse -Force | select -ExpandProperty Name)

 return $array

} -ErrorAction SilentlyContinue

}

function listScripts {

param($count=0)

$ScriptList = getScripts

foreach ($item in $ScriptList){

 Write-Host "$count. " ($item).Substring(4)
 $count++

 }

 }

function runScript {

$ScriptList = getScripts

$userInput = Read-Host "what script to you want to call?"

invoke-command -ComputerName $ComputerName -ArgumentList $ScriptPath, $ScriptList, $userInput -ScriptBlock {

param ($ScriptPath, $ScriptList, $userInput)

$uniScript = Get-ChildItem -Path $ScriptPath -Filter $ScriptList[$userInput] -Recurse -Force | select -ExpandProperty FullName

& $uniScript

}

   




}

if($list -ne $false){

    listScripts

}
elseif($Uninstall -ne $false){

    runScript
}

