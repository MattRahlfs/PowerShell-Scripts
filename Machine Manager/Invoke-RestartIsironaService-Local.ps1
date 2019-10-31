function getService{


if(Get-Service -Name "isirona deviceconx service", "isirona deviceescort service"){return $true}
else{return $false}


}

#uses the get-service CMD to get the service object and pipes into the stop-serivce CMD to stop, the same to start
#the services and waits a period of time before continuing
function restartServices{


Get-Service -Name "isirona deviceconx service" | Stop-Service -Force
Start-Sleep -Seconds 1
Get-Service -Name "isirona deviceescort service" | Stop-Service -Force


Start-Sleep -Seconds 5


Get-Service -Name "isirona deviceconx service" | Start-Service
Start-Sleep -Seconds 1
Get-Service -Name "isirona deviceescort service" | Start-Service


}

if(getService){restartServices}