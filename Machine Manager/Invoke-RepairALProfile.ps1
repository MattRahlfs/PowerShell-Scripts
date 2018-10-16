
Try {

$username = Read-Host -Prompt "What is the name of the users profile"
$compname = Read-Host -Prompt "What is the name of the machine"


$SID = (Get-ADUser -Identity $username | Select -ExpandProperty SID).value


If(& "$PSScriptRoot\itmo.ps1" $compname){


    If(Invoke-Command -ComputerName $compname -ArgumentList $username -ScriptBlock {param ($username) Test-Path -Path "C:\Users\$username"}){

        Write-Output "Verified the users profile exists"

        Invoke-Command -ComputerName $compname -ScriptBlock {Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 0}
        Restart-Computer -ComputerName $compname -Force
        Write-Output "Turned off autologon, restarting the computer to allow the OS to be manipulated."
        Start-Sleep -Seconds 10

        

      If(& "$PSScriptRoot\itmo.ps1" $compname){
                    

        
        Invoke-Command -ComputerName $compname -ScriptBlock {Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1}
        Invoke-Command -ComputerName $compname -ArgumentList $username -ScriptBlock {param ($username) Rename-Item -Path "C:\Users\$username" -NewName "$username.old" -Force} -ErrorAction SilentlyContinue
        Invoke-Command -ComputerName $compname -ArgumentList $SID -ScriptBlock {param ($SID) Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID" -Recurse -Force}
        Write-Output "Enabled autologon, the users profile was renamed to $username.old. Restarting the computer one more time."
        Restart-Computer -ComputerName $compname -Force
      
      }

                    
  
   }
    else{Write-Output "The user profile doesnt exist"}
    
}
else{Write-Output "Unable to connect to the computer"}

        




       
      
    


}
Catch{Write-Output "user profile repair failed"}

