

$compname = Read-Host "Enter the computer name"

Invoke-Command -ComputerName $compname -ScriptBlock {query session}

$sessionID = Read-Host "What ID do you want to logoff?"

Invoke-Command -ComputerName $compname -ArgumentList $sessionID -ScriptBlock {param ($sessionID) logoff $sessionID}

