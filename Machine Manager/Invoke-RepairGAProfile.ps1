

$username = Read-Host "Enter the username of the profile that is going to be repaired"
$compname = Read-Host "What computer is the profile located on"

$SID = (Get-ADUser -Identity $username | Select -ExpandProperty SID).value


If (Test-Connection -ComputerName $compname -Count 1 -ErrorAction Stop){

    If(Invoke-Command -ComputerName $compname -ArgumentList $username -scriptblock {param($username)
       Test-Path -Path "C:\users\$username"}){

        Write-Output "The computer is online and the user profile exists"
        
        Restart-Computer -ComputerName $compname -Force}

        Start-Sleep -Seconds 10

        
        Write-Output "Checking the computer to make sure it is back online and the file system can be accessed."
        
                    

       If (& "$PSScriptRoot\Invoke-ITMO.ps1" $compname){

       Write-Output "changing $username to $username.old"

       Invoke-Command -ComputerName $compname -ArgumentList $username -ScriptBlock {param ($username) 
        Rename-Item -Path "C:\Users\$username" -NewName "$username.old" -Force} -ErrorAction SilentlyContinue

       Write-Output "Changed the directiry name"

       Write-Output "Deleting the registry key"

       Invoke-Command -ComputerName $compname -ArgumentList $SID -ScriptBlock {param ($SID) 
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID" -Recurse -Force}

       Write-Output "Deleted, restarting the computer"

       Restart-Computer -ComputerName $compname -Force
          
       }

        


}
        
Else{Write-Output -ForegroundColor Red "Failed to connect to the computer"}




