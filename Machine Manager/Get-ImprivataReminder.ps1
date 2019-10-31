param (

   $ComputerName
)

& $PSScriptRoot\Invoke-RemoveOldData.ps1 "C:\Windows\Mercy\ImprivataReminder-log*" 7

$invokeLogFile = "$PSScriptRoot\Invoke-LogToFile.ps1"
$logPath = "C:\Windows\Mercy\ImprivataReminder-log $(Get-Date -UFormat '%m%d%y').txt"

& $invokeLogFile $logPath "Starting the the Imprivata Reminder script"

$UserName = $env:USERNAME

& $invokeLogFile $logPath "The username was set to $username"

#both variables needs a value and cannot be null
if(($ComputerName -ne $null) -and ($UserName -ne $null)){

& $invokeLogFile $logPath "Both the computername and username variavble are not null $Computername"

#checks if the computer is in AD or not, will only continue if computer is in AD
try {

if(Get-ADComputer -Identity $ComputerName -ErrorAction Stop){$Result = $true

& $invokeLogFile $logPath "The computer is in AD"}

}
catch{

& $invokeLogFile $logPath "The computer is not in AD"
write-host "this computer is not in AD"

}

#if the computer is in AD it will create the task 
if($Result -eq $true){

& $invokeLogFile $logPath "creating the task and checking if it already exists"
#checks if there is a task already created for this computer and either creates it or runs the script
if((Get-ScheduledTask -TaskName $ComputerName -ErrorAction SilentlyContinue | where state -ne $null | select -ExpandProperty taskname) -eq $null){

#
$a = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-nologo -windowstyle hidden & '$PSSCriptRoot\Get-ImprivataReminder.ps1' -ComputerName $ComputerName -UserName $UserName" -WorkingDirectory C:\MachineManager

$t = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(2) -RepetitionDuration (New-TimeSpan -Days 1) -RepetitionInterval (New-TimeSpan -Hours 1)

$p = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -RunLevel Highest 

$s = New-ScheduledTaskSettingsSet -WakeToRun -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName $ComputerName -Action $a -Trigger $t -Settings $s -Principal $p -Description "Checks if imprivata is installed on the computer $ComputerName"
& $invokeLogFile $logPath "Registerd the task"

}
Else{

& $invokeLogFile $logPath "the task already exists starting a job to check for imprivata"
#the main chunk of the script is run through this job
Start-Job -Name "IPER $ComputerName" -ArgumentList $ComputerName, $UserName, $invokeLogFile, $logpath -ScriptBlock {

param ($ComputerName,$UserName,$invokeLogFile,$logpath)

<#specifies the reg path we will be working with, creates a remote session so it only needs to keep a single port open, 
retrieves the email for the user that ran the script#>
$RegPath="HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
$RemoteSession=New-PSSession -ComputerName $ComputerName -Name $ComputerName -ErrorAction SilentlyContinue
$Email=Get-ADUser -Identity $UserName -Properties EmailAddress | select -ExpandProperty EmailAddress

& $invokeLogFile $logPath "checking the policy of the computer"

#checks if the computer is a memberof the imprivata groups and sets a variable depending on hosp/clnc app/work
if ((Get-ADComputer -Identity $ComputerName –Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | where name -Like "*Imprivata.CLN*" | select name) -and 
(Get-ADComputer -Identity $ComputerName –Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | where name -Like "*ImprivataAgentforAppStation*" | select name)){

Write-host "This machine has clinic appstation imprivata pushed"
$PolicyType = "Clinic Appation"

}
Elseif((Get-ADComputer -Identity $ComputerName –Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | where name -Like "*Imprivata.CLN*" | select name) -and 
(Get-ADComputer -Identity $ComputerName –Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | where name -Like "*ImprivataAgentforRegular*" | select name)){

write-host "This machine has clinic workstation imprivata pushed"
$PolicyType = "Clinic Workstation"

}
Elseif(Get-ADComputer -Identity $ComputerName –Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | where name -Like "*ImprivataAgentforAppStation*" | select name){

write-host "This machine has imprivata appstation pushed"
$PolicyType = "Hospital Appstation"

}
Elseif(Get-ADComputer -Identity $ComputerName –Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | where name -Like "*ImprivataAgentforRegular*" | select name){

Write-host "This machine has workstation imprivata pushed"
$PolicyType = "Hospital Workstation"

}
Else{& $invokeLogFile $logPath "The machine has not been pushed imprivata"}

& $invokeLogFile $logPath "The machine is a [$PolicyType]"

#checks if the computer is offline
if(Test-Connection -ComputerName $ComputerName -Count 1 -ErrorAction SilentlyContinue){

    & $invokeLogFile $logPath "The computer is online"
    #ensures the RegPath is valid
    if(Invoke-Command -Session $RemoteSession -ArgumentList $RegPath -ScriptBlock {
        param ($RegPath) 
        Test-Path -Path $RegPath}){
        & $invokeLogFile $logPath "The registry uninstall key is valid"
        Write-Host "The Path $RegPath is valid"

       <#checks the registry if imprivata is under HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall,
        if imprivata is under the location then it will send an email to the user that its policy can be updated
        and unregisters the task#> 
        & $invokeLogFile $logPath "checking the computer for the imprivata uninstall registry string"            
        if(Invoke-Command -Session $RemoteSession -ArgumentList $RegPath -ScriptBlock {
            param ($RegPath) 

            Get-ChildItem -Path $RegPath | Get-ItemProperty | where displayname -like "*Imprivata*"}){


            Write-Host "Imprivata is installed on $ComputerName"
            Send-MailMessage -To $Email -From PowershellScripts@mercy.net -Body "Imprivata has been installed on $ComputerName and needs the policy for a $PolicyType machine." -Subject "Imprivata Policy Reminder" -SmtpServer smtp.mercy.net           
            Unregister-ScheduledTask -TaskName $ComputerName -Confirm:$false
            & $invokeLogFile $logPath "Imprivata is installed on the machine and sending an email to $Email, the task has been unscheduled"
            
            }

        Else{Write-Host "Imprivata is not installed on $ComputerName"
                & $invokeLogFile $logPath "Imprivata is not on the computer"

             <#if imprivata is not installed and the script has completed (run once an hour for 24 hours),
             it will email the user something went wrong with the installation#>
             if((Get-ScheduledTaskInfo -TaskName $ComputerName | select -ExpandProperty NextRunTime) -eq $null){

                Send-MailMessage -To $Email -From PowershellScripts@mercy.net -Body "The script has ran once an hour for 24 hours and still cannot find imprivata on the computer $ComputerName" -Subject "Imprivata Policy Reminder" -SmtpServer smtp.mercy.net
                Unregister-ScheduledTask -TaskName $ComputerName -Confirm:$false
                
             }
            
        }
        
        }
    Else{Write-Host "The Path is not valid"}

    }
Else{Write-Host "Unable to connect to the machine $ComputerName"}



Remove-PSSession -Name $ComputerName

 }

 Wait-Job -Name "IPER $ComputerName"

 Get-Job -Name "IPER $ComputerName" | Remove-Job
 
}


}


}
Else {Write-Host "at least one of the Variables is null, you need to specify a computer to check and a username to send the email reminder to"}

