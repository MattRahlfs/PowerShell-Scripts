
param(

$ComputerName

)

Start-Process mstsc.exe -ArgumentList "/v:$ComputerName /f"

