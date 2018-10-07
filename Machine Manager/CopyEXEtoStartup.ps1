param(

[string[]]$ComputerName,
[string]$Name,
[string]$EXEpath

)

$creds = Get-Credential
$ICUMonitorPath = "C:\Program Files (x86)\Epic\v8.3\Monitor\ICUMonitor.exe"
$StartupFolder = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"


foreach($Computer in $ComputerName){


if(Test-Connection -ComputerName $computer -Count 1 -TimeToLive 2 -ErrorAction SilentlyContinue){

Invoke-Command -ComputerName $computer -Credential $creds -ArgumentList $StartupFolder, $EXEpath, $Name -ScriptBlock{

param (
$StartupFolder,
$EXEpath,
$Name
)


New-Item -ItemType SymbolicLink -Path $StartupFolder -Name "$Name.lnk" -Value $EXEpath 

}

}
Else{Write-Host "Couldnt connect to $computer"}

}
