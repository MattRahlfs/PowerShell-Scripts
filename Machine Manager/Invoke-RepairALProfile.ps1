param (

$_computerName

)


& "$PSScriptRoot\Invoke-RemoveOldData.ps1" "C:\Windows\Mercy\Invoke-RepairALProfile*" 7

$invokeLogFile = "$PSScriptRoot\Invoke-LogToFile.ps1"
$logPath = "C:\Windows\Mercy\Invoke-RepairALProfile $(Get-Date -UFormat '%m%d%y').txt"

& $invokeLogFile $logPath "Starting the Set-AutoLogon Script on $_computerName"

$_userName = ("U" + $_computerName.Substring(1))
$SID = (Get-ADUser -Identity  $_userName| Select -ExpandProperty SID).value

function enable_AutoLogon(){


try{
    Invoke-Command -ComputerName $_computerName -ScriptBlock {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1}
    Write-Output "Enabled Autologon, Restarting the computer to log back into the U account"
    Start-Sleep -Seconds 10
    Restart-Computer -ComputerName $_computerName -Force
    & $invokeLogFile $logPath "Re-Enabled the autologin reg key and restarted the computer"
    }
catch{Write-Output "Unable to enable AutoLogon"}

}


function delete_RegKey_Ufolder(){

try{
 
 Start-Sleep -Seconds 2
 Invoke-Command -ComputerName $_computerName -ArgumentList $_userName -ScriptBlock {param ($_userName) 
 

    
    if(Get-Item "C:\users\$_userName.old" -ErrorAction SilentlyContinue){

        Remove-Item "C:\Users\$_userName.old" -Recurse -Force

        }
 
 
 }
  
 Start-Sleep -Seconds 2
 Invoke-Command -ComputerName $_computerName -ArgumentList $_userName -ScriptBlock {param ($_userName) Rename-Item -Path "C:\Users\$_userName" -NewName "$_userName.old" -Force}
 Start-Sleep -Seconds 2
 Invoke-Command -ComputerName $_computerName -ArgumentList $SID -ScriptBlock {param ($SID) Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID" -Recurse -Force}
 Start-Sleep -Seconds 2
 

 & $invokeLogFile $logPath "Removed .old profile if it exists, deleted the users regkey and renamed the current uaccount profile to $username.old"
        
}
catch{Write-Host "Unable to remove user data"}


}


function wait_For_Online(){

Try{
    
    Write-Output "Waiting until Machine is back online."
    do{
        
        $_timesLooped += 1

        Write-Host -NoNewline "."
        Start-Sleep -Seconds 5
       
        if($_timesLooped -gt 60){
            Write-Output "`nExceeded 5 minutes attempting to reconnect to the computer"
            throw "Exceeding Time Limit"}


    }until(& "$PSScriptRoot\Get-MachineConnection.ps1" $_computerName)

    Write-Output "`n"
    
    & $invokeLogFile $logPath "The machine came back online"
}
catch{Write-Output "Could not reconnect to the computer."
& $invokeLogFile $logPath "could not reconnect to the computer"}

Write-Output "`n"

}


function disable_AutoLogon{

Try{
    
    Invoke-Command -ComputerName $_computerName -ScriptBlock {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 0}

    Restart-Computer -ComputerName $_computerName -Force
    Write-Output "Turned off autologon, restarting the computer to allow the OS to be manipulated."
    Start-Sleep -Seconds 10
    
    & $invokeLogFile $logPath "Disabled autologon and restarted the computer"
}
catch{Write-Output "Unable to disable AutoLogon"}
    
}



function check_Profile{

Try{

    If(Invoke-Command -ComputerName $_computerName -ArgumentList $_userName -ScriptBlock {
        param ($_userName) Test-Path -Path "C:\Users\$_userName"}){
        Write-Output "Verified the U account profile is present."
        
        }
    else{Write-Output "The U account doesnt exist."}

    & $invokeLogFile $logPath "checked the existence of the uaccount profile"
}
catch{Write-Output "Unable to verify the U accont profile."}


}


function check_Machine{

Try{

    if(& "$PSScriptRoot\Get-MachineConnection.ps1" $_computerName){
        Write-Output "Verified the computer is online."
        }

        & $invokeLogFile $logPath  "The machine is online"
}
catch{Write-Output "Unable to connect to the computer."}
}

check_Machine
check_Profile
disable_AutoLogon
wait_For_Online
delete_RegKey_Ufolder
enable_AutoLogon