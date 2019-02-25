param (

$ComputerName

)


Invoke-Command -ComputerName $ComputerName -ScriptBlock {New-Item -Path "C:\Installs" -ItemType Directory -Force}

Write-Host "`nCopying West Region PROD Install PKG v1.zip`n"


Copy-Item -Path "\\wdc-veisrnamp01\ics software\ICS Installation Files\West Region PROD Install PKG v1.zip" -Destination "\\$ComputerName\C$\Installs" -Force

Write-Host "Extracting the .zip"

Expand-Archive -Path "\\$ComputerName\C$\Installs\West Region PROD Install PKG v1.zip" -DestinationPath "\\$ComputerName\C$\Installs\West Region PROD Install PKG v1"


