$a = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "& C:\MachineManager\TestingFile.ps1" 

$t = New-ScheduledTaskTrigger -once -at (Get-Date).AddSeconds(2) -RepetitionDuration (New-TimeSpan -Days 1) -RepetitionInterval (New-TimeSpan -Minutes 1)

$p = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -RunLevel Highest

$s = New-ScheduledTaskSettingsSet -WakeToRun -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName "newtesttask" -Action $a -Trigger $t -Principal $p -Settings $s -Description "checking thinga majigs" -Force

