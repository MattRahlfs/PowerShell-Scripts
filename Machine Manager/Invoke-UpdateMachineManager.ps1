function Get-InternetFile($URL, $Path){

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

(New-Object System.Net.WebClient).DownloadFile($URL, $Path)

}
#run get-internetfile to download the zip from github
Get-InternetFile "http://github.com/MattRahlfs/PowerShell-Scripts/archive/master.zip" "c:\temp\MachineManager.zip"


