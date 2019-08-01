
param(

$ComputerName = "w2m2mxm2"

)


Invoke-Command -ComputerName $ComputerName -ScriptBlock {query session}

[int]$sessionID = Read-Host "What ID do you want to logoff?"

if($sessionID -isnot [int] -or ($sessionID -eq 0)){exit}
else{
Invoke-Command -ComputerName $ComputerName -ArgumentList $sessionID -ScriptBlock {param ($sessionID) logoff $sessionID}
}



