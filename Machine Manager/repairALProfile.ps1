


Try {

$username = Read-Host -Prompt "What is the name of the users profile"
$compname = Read-Host -Prompt "What is the name of the machine"
$creds = Get-Credential -Message "Enter your credentials"

$SID = (Get-ADUser -Identity $username | Select -ExpandProperty SID).value

write-host "gathered all data"

If(Test-Connection -ComputerName $compname -count 1 -TimeToLive 3){
write-host "tested the connection to $compname"

    If(Invoke-Command -ComputerName $compname -ArgumentList $username -Credential $creds -ScriptBlock {param ($username) Test-Path -Path "C:\Users\$username", "C:\Users\$username*"}){

        write-host "tested the path the $username users folder"

        Invoke-Command -ComputerName $compname -Credential $creds -ScriptBlock {Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 0}
        Restart-Computer -ComputerName $compname -Force
        write-host "set the auto login value to 0 and restarted the computer now waiting 30 seconds to test the connection again"
        Start-Sleep -Seconds 30

        
        write-host "starting the forloop to check the computer on the network and the $username users profile again after the restart"
        for($timer=0; $timer -lt 100){

    
            While($timer -lt 100){

                If(Test-Connection -ComputerName $compname -Count 1 -ErrorAction SilentlyContinue){
                    

                    If (Invoke-Command -ComputerName $compname -ArgumentList $username -ScriptBlock {param ($username) Test-Path -Path "C:\Users\$username", "C:\Users\$username*" -Exclude "C:\Users\*.old"} -ErrorAction SilentlyContinue){
                        write-host "`nthe path is also still valid"
                        write-host "`nSystem Online" -ForegroundColor Green
                        $timer=100

                        write-host "the computer and the path are both available"
                        Invoke-Command -ComputerName $compname -Credential $creds -ScriptBlock {Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1}
                        Invoke-Command -ComputerName $compname -Credential $creds -ArgumentList $username -ScriptBlock {param ($username) Rename-Item -Path "C:\Users\$username" -NewName "$username.old" -Force} -ErrorAction SilentlyContinue
                        Invoke-Command -ComputerName $compname -Credential $creds -ArgumentList $SID -ScriptBlock {param ($SID) Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID" -Recurse -Force}
                        write-host "re enabled the autologin, renamed the profile, removed the reg key, restarting the computer"
                        Restart-Computer -ComputerName $compname -Force}

                    Else{Write-Host "." -ForegroundColor Red -BackgroundColor White -NoNewline}

                        }
                Else{Write-Host "." -ForegroundColor Red -BackgroundColor White -NoNewline
                    $timer=$timer+1}

                Start-Sleep -Seconds 5
  
            }

        }

        




       
        }
    Else{Write-Host "THe Path Doesnt Exist"}
}
Else{Write-Host -ForegroundColor Red "Failed to connect to the computer"
    log-ToFile  log-ToFile -Path "C:\Machine Manager Log.txt" -Content "Failed to reach $compname"}

}
Catch{Write-Host "user profile repair failed"}

