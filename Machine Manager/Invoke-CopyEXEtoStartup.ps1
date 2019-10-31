param(

[string[]]$ComputerName,
[string]$EXEpath = 'C:\MachineManager\EXE to copy\OptiFlex_03.lnk'

)


#$ICUMonitorPath = "C:\Program Files (x86)\Epic\v8.3\Monitor\ICUMonitor.exe"
$StartupFolder = "ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"


foreach($Computer in $ComputerName){


if(Test-Connection -ComputerName $computer -Count 1 -TimeToLive 2 -ErrorAction SilentlyContinue){

Copy-Item -Path $EXEpath -Destination "\\$Computer\C$\$StartupFolder"

}
Else{Write-Host "Couldnt connect to $computer"}

}
