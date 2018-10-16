$computername = Read-Host "whats the computer name"

$remosesh = New-PSSession -ComputerName $computername


copy -path "C:\CitrixReceiver.exe" -Destination "\\$computername\c$\" -Force
Write-Host "copied the exe"

Start-Sleep -Seconds 3

invoke-command -Session $remosesh -ScriptBlock {

Start-Process -FilePath "C:\CitrixReceiver.exe" -ArgumentList "/silent /uninstall" 

}

Write-Host "started the exe uninstall"

Start-Sleep -Seconds 10

Remove-Item -Path "\\$computername\C$\CitrixReceiver.exe" -Force

Write-Host "removed the exe"

Invoke-Command -Session $remosesh -ScriptBlock {

Get-WmiObject Win32_product | where name -like "Citrix*" | select name
}

Remove-PSSession -ComputerName $computername

#Restart-Computer -ComputerName $computername -Force

