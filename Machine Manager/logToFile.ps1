

param($Path = "c:\Log-ToFile.txt", $Content = "")

$timestamp = Get-Date -UFormat "%m/%d/%Y %T`n"

Write-Output "### $timestamp" | Out-File -Append -FilePath "$Path" 

$Content | Out-File -Append -FilePath "$Path"

Write-Output "################################################ "| Out-File -Append -FilePath "$Path"

