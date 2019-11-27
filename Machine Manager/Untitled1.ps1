$File = "http://github.com/MattRahlfs/PowerShell-Scripts/archive/master.zip"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(New-Object System.Net.WebClient).DownloadFile($File, "c:\temp\masterfile.zip")