$computername = Read-Host "whats the computer name"



copy -path "C:\CitrixReceiver.exe" -Destination "\\$computername\c$\" -Force
Write-Host "copied the exe"

Write-Output "Starting to sleep for 3 seconds"
Start-Sleep -Seconds 3

Write-Output "Starting to invoke the exe with the arguments silent uninstall"
invoke-command -ComputerName $computername -ScriptBlock {

Start-Process -FilePath "C:\CitrixReceiver.exe" -ArgumentList "/silent /uninstall" 

}

Write-Host "started the exe uninstall"

Start-Sleep -Seconds 10

Remove-Item -Path "\\$computername\C$\CitrixReceiver.exe" -Force

Write-Host "removed the exe"

Invoke-Command -ComputerName $computername -ScriptBlock {

Get-WmiObject Win32_product | where name -like "Citrix*" | select name
}



#Restart-Computer -ComputerName $computername -Force

