
$ComputerName = Read-Host "Whats the computer name"

Start-Process mstsc.exe -ArgumentList "/v:$ComputerName /f"

