param (

$_ComputerName = "wd6dlzv2"

)


Try{Test-Connection -ComputerName $_ComputerName -Count 1 -ErrorAction Stop}
Catch{Write-Output "Unable to connect to the remote computer"}

Try{Copy-Item "C:\Users\mrahlfs1\OneDrive - Mercy Online\Powershell Scripts\TCIPAAppManager - Shortcut.lnk" -Destination "\\$_ComputerName\c$\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" -Force -ErrorAction Stop}
Catch{Write-Output "Unable to copy the .lnk"}

Try{Copy-Item "\\stlo-nas01\appsconfigs\ManualApps\TopazSignatureDrivers_2.12.26_R01" -Destination "\\$_ComputerName\c$" -Recurse -Force -ErrorAction Stop}
Catch{Write-Output "Unable to copy Topaz drivers to C:\"}