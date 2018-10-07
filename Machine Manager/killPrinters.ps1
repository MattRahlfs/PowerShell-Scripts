
Write-Output "`n"

Try{
If (Test-Connection -ComputerName $hosts -count 1 -TimeToLive 3 -quiet){
Write-Output "Successfully connected to the computer"
Write-Output "Checking if the spooler is running"
    try{
        If(Get-Service -ComputerName $hosts -Name Spooler | Where Status -eq "Running"){
           Write-Output "Spooler service is running, stopping service"
           Invoke-Command -ComputerName $hosts -scriptblock{Stop-Service -Force -Name Spooler}
           If(Get-Service -ComputerName $hosts -Name Spooler | Where Status -eq "Stopped"){
              
              Write-Output "Service is stopped, deleting files from C:\Windows\System32\spool\PRINTERS\"
              Invoke-Command -ComputerName $hosts -scriptblock{$jobLoc = "C:\Windows\System32\spool\PRINTERS\"
                                                               Remove-Item -Path $jobLoc -recurse}
            }
        }
        Else{Write-Output "Spooler service is not running"}
        Write-Output "Starting the spooler"
        Invoke-Command -computername $hosts -scriptblock{Start-Service -Name Spooler}}
    Catch{Write-Host "There was and error while stopping the spooler and deleting stuck jobs" -ForegroundColor Red}
}
}
Catch{Write-Host "Cannot connect to the computer" -ForegroundColor Red}
