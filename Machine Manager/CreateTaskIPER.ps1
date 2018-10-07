
param(

$ComputerName,

$UserName

)

$a = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-noexit & '$PSSCriptRoot\IPER.ps1' -ComputerName $ComputerName -UserName $UserName"

$t = New-ScheduledTaskTrigger -once -At (Get-Date).AddSeconds(2) -RepetitionDuration (New-TimeSpan -Days 1) -RepetitionInterval (New-TimeSpan -Hours 1)

$p = New-ScheduledTaskPrincipal -UserId "$env:USERDNSDOMAIN\$username" -RunLevel Highest

$s = New-ScheduledTaskSettingsSet -WakeToRun 

Register-ScheduledTask -TaskName $ComputerName -Action $a -Trigger $t -Settings $s -Principal $p -Description "Checks if imprivata is installed on the computer $ComputerName"
