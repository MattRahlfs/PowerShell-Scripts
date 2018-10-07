<#GLOBAL VARIABLES#>
$scriptloop = $true
$creds = Get-Credential
<#END GLOBAL VARIABLES#>


<#This part of the script forces a loop and asks the user what they want to do#>
While ($scriptloop -EQ $true) {
       
       Write-Output "`n`n"
       Write-Host -ForegroundColor Green "Menu"
       Write-Host -ForegroundColor Yellow "1. Get the Network Adapter Information `n2. Get the Processes on the machine `n3. Fix Printer Issues and Stuck Jobs `n4. Manage Services `n5. Get Monitor Serial Number `n6. Log a user off `n7. Uninstall Citrix `n8. RDP Into a Machine `n0. EXIT"
       $userInput = Read-Host -Prompt "Enter an option"

If($userInput -eq 1){& "$PSScriptRoot\gnetAdapterNFO.ps1"}
ElseIf($userInput -eq 2){$hosts = Read-Host -Prompt "`nEnter the computer name"
& "$PSScriptRoot\gProcessNFO.ps1"}
ElseIf($userInput -eq 3){$hosts = Read-Host -Prompt "`nEnter the computer name"
killPrinters}
ElseIf($userInput -eq 4){$hosts = Read-Host -Prompt "`nEnter the computer name"
& "$PSScriptRoot\KOSServices.ps1"}
ElseIf($userInput -eq 5){$Computers = Read-Host -Prompt "`nEnter the computer name" 
$Path = Read-Host -Prompt "`nEnter the Path you want"
& "$PSScriptRoot\GetMonitorSerial" $Computers $Path}
ElseIf($userInput -eq 6) {& "$PSScriptRoot\loguseroff.ps1"}
ElseIf($userInput -eq 7) {& "$PSScriptRoot\UninstallCitrix.ps1"}
ElseIf($userInput -eq 8) {& "$PSScriptRoot\RDPN.ps1"}
ElseIf($userInput -eq 0){$scriptloop = $false}
Else{Write-Output "`nEnter a valid number"}
}

