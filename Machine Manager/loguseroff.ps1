

$compname = Read-Host "Enter the computer name"

Invoke-Command -ComputerName $compname -Credential $creds -ScriptBlock {query session}

$sessionID = Read-Host "What ID do you want to logoff?"

Invoke-Command -ComputerName $compname -Credential $creds -ArgumentList $sessionID -ScriptBlock {param ($sessionID) logoff $sessionID}

