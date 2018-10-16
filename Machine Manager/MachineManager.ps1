
$scriptloop = $true
#$AccountCredentials = Get-Credential




<#This part of the script forces a loop and asks the user what they want to do#>
While ($scriptloop -EQ $true) {
       
       Write-Output "`n`n"
       

       
       
       Write-Host -ForegroundColor Green "`t   Menu" -NoNewline
       Write-Host -ForegroundColor Cyan "    $ComputerName" 
       Write-Host -ForegroundColor Yellow "
       1. Get the Network Adapter Information 
       2. Get the Processes on the machine 
       3. Fix Printer Issues and Stuck Jobs 
       4. Manage Services 
       5. Get Monitor Serial Number 
       6. Log a user off 
       7. Uninstall Citrix 
       8. RDP Into a Machine
       9. Imprivata Policy change reminder
       C. To change the computer name 
       0. EXIT
       "

       $userInput = Read-Host -Prompt "Enter an option"

If($userInput -eq 1){& "$PSScriptRoot\Get-NetworkInfo.ps1" $ComputerName}

ElseIf($userInput -eq 2){& "$PSScriptRoot\Get-ProcessInfo.ps1" $ComputerName}

ElseIf($userInput -eq 3){& "$PSScriptRoot\Invoke-RepairPrinter.ps1" $ComputerName}
ElseIf($userInput -eq 4){& "$PSScriptRoot\Get-Services.ps1" $ComputerName}
ElseIf($userInput -eq 5){& "$PSScriptRoot\Get-MonitorSerial" $ComputerName}
ElseIf($userInput -eq 6) {& "$PSScriptRoot\Invoke-Logoff.ps1" $ComputerName}
ElseIf($userInput -eq 7) {& "$PSScriptRoot\Invoke-RemoveCitrix.ps1"}
ElseIf($userInput -eq 8) {& "$PSScriptRoot\Invoke-RemoteDesktop.ps1" $ComputerName}
ElseIf($userInput -eq 9) {$getEmail = Read-Host "What is the username the email will be sent to?" 
& "$PSScriptRoot\Get-ImprivataReminder.ps1" $ComputerName $getEmail}
ElseIf($userInput -eq "C"){$ComputerName = Read-Host "Enter the Computer name"}
ElseIf($userInput -eq 0){$scriptloop = $false}
Else{Write-Output "`nEnter a valid number"}
}

