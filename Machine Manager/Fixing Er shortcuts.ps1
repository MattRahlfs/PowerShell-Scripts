$ICUMonitorPath = "C:\ICUMonitor.lnk"
$StartupFolder = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"


foreach ($Computer in (Get-Content C:\ERMachines.txt)){

if(Test-Path "\\$computer\c$\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\ICUMonitor.lnk"){Write-Output "$Computer has the path"

Remove-Item -Path "\\$computer\c$\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\ICUMonitor.lnk" -Force

Copy-Item -Path $ICUMonitorPath -Destination "\\$computer\c$\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\"

 }


}