

Param(

[switch]$Get,

[switch]$Add,

[string]$NewExcuse

)


#make sure the file exists
if(Test-Path -Path "$PSScriptRoot\Excuses.txt"){$PathExists=$true}
else{Write-Host "Path Does not exist, Create an excuse file."}



#function to give an excuse and send it to clipboard
function GetExcuse {

$CurrentExcuse = Get-Random -InputObject (Get-Content -Path "$PSScriptRoot\Excuses.txt")

Set-Clipboard -Value $CurrentExcuse

Write-Host -ForegroundColor Green "`n*******`n"

Write-Host "$CurrentExcuse"

Write-Host -ForegroundColor Green "`n*******"


}


#function to add a excuse to the "database"
function AddExcuse{

if(($Add) -and ($NewExcuse -NE $null)){$NewExcuse | Out-File -FilePath "$PSScriptRoot\Excuses.txt" -Append}

}
    

if(($PathExists) -and ($Get)){GetExcuse}
elseif(($PathExists) -and ($Add)){AddExcuse}