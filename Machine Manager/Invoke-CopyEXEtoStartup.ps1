param(

[string[]]$ComputerName,
[string]$EXEpath

)



$StartupFolder = "ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"


foreach($Computer in $ComputerName){


if(Test-Connection -ComputerName $computer -Count 1 -TimeToLive 2 -ErrorAction SilentlyContinue){

Copy-Item -Path $EXEpath -Destination "\\$Computer\C$\$StartupFolder"

}
Else{Write-Host "Couldnt connect to $computer"}

}
