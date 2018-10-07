

$username = Read-Host "Enter the username of the profile that is going to be repaired"
$compname = Read-Host "What computer is the profile located on"

$SID = (Get-ADUser -Identity $username | Select -ExpandProperty SID).value


If (Test-Connection -ComputerName $compname -Count 1 -ErrorAction Stop){

    If(Invoke-Command -ComputerName $compname -ArgumentList $username -scriptblock {param($username)
       Test-Path -Path "C:\users\$username","C:\users\$username*"}){

        Write-Host "The computer is online and the user profile exists, it may be a temp profile though"

        Restart-Computer -ComputerName $compname -Force}

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

                        Invoke-Command -ComputerName $compname -ArgumentList $username -ScriptBlock {param ($username) 
                            Rename-Item -Path "C:\Users\$username" -NewName "$username.old" -Force} -ErrorAction SilentlyContinue

                        Invoke-Command -ComputerName $compname -ArgumentList $SID -ScriptBlock {param ($SID) 
                            Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID" -Recurse -Force}


                        Restart-Computer -ComputerName $compname -Force}

                    Else{Write-Host "." -ForegroundColor Red -BackgroundColor White -NoNewline}

                        }
                Else{Write-Host "." -ForegroundColor Red -BackgroundColor White -NoNewline
                    $timer=$timer+1}

                Start-Sleep -Seconds 5
  
            }

        }

        



        
}Else{Write-Host -ForegroundColor Red "Failed to connect to the computer"}




