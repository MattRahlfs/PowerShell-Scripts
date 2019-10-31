param(

$ComputerName

)

Start-Sleep -Seconds 30
$starttime = Get-Date

do{

if(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet){
& $PSScriptRoot\Invoke-AlertNoise.ps1
Start-Process powershell.exe "-noexit 
Write-Host -ForegroundColor Red '$ComputerName is now online'"
exit
}else{Start-Sleep -Seconds 30}

}
until((Get-Date) -ge $starttime.AddMinutes(5))

