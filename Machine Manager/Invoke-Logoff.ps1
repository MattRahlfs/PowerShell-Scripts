param(

$ComputerName

)


Invoke-Command -ComputerName $ComputerName -ScriptBlock {query session}

$sessionID = Read-Host "What ID do you want to logoff?"

Invoke-Command -ComputerName $ComputerName -ArgumentList $sessionID -ScriptBlock {param ($sessionID) logoff $sessionID}

