
#removes old logs from the past month
function removeOldData{

param(

$Path,

$Age

)


Try{


Get-ChildItem -Path $Path | Where {$_.LastWriteTime -lt (Get-Date).AddDays(-$Age)} | Remove-Item -Force

}
Catch{$_.ErrorMessage
      Write-Output "Unable to remove old files"}


}
removeOldData -Path "C:\temp\IsironSerivceRestart.txt" -Age 32
####################################################################################


#file logging for this script
function logFile{

param(

 $Path = "C:\Temp\IsironaServiceRestart\LOG.txt",

 $Content = ""
 
 )



Write-Output "### $(Get-Date -UFormat '%m/%d/%Y %T')`n`n" | Out-File -Append -FilePath "$Path"

$Content | Out-File -Append -FilePath "$Path"

Write-Output "################################################ "| Out-File -Append -FilePath "$Path"


}


#test if the file containing the computer names exists
function testFilePath{

###
logFile -Content "Started to test the file path C:\Temp\IsironaServiceRestart\computers.txt"


if((Test-Path "C:\Temp\IsironaServiceRestart\Computers.txt") -eq $false){

###
logFile -Content "File path did not exists, creating the directory and file"


New-Item -ItemType Directory -Name "IsironaServiceRestart" -Path "C:\Temp"
Start-Sleep -Seconds 1
New-Item -ItemType File -Name "Computers.txt" -Path "C:\Temp\IsironaServiceRestart"


###
logFile -Content "Opening a new powershell window informing user to add copmuter names to the file, opening notepad with the file"


Start-Process powershell.exe "-noexit 
Write-Host -ForegroundColor Red 'Please enter at least 1 computer name into the file located:'
Write-Host -ForegroundColor Red 'C:\Temp\IsironaServiceRestartComputers.txt'
Write-Host -ForegroundColor Yellow 'This window will automatically close in 30 seconds'
start-sleep -seconds 30
exit"
Start-Process notepad.exe "C:\Temp\IsironaServiceRestart\computers.txt"
}
else{

###
logFile -Content "The file path exists"

return $true}

}

#gets the service from the remote computer and returns the boolean value
function getService{

param($Computername)

###
logFile -Content "Started to get/check the services"


if(Get-Service -ComputerName $Computername -Name "isirona deviceconx service", "isirona deviceescort service"){

###
logFile -Content "The services exist"


return $true}
else{

###
logFile -Content "The services dont exist"


return $false}


}

#uses the get-service CMD to get the service object and pipes into the stop-serivce CMD to stop, the same to start
#the services and waits a period of time before continuing
function restartServices{

param($Computername)

###
logFile -Content "Started to restart the services"


Get-Service -ComputerName $Computername -Name "isirona deviceconx service" | Stop-Service -Force
Start-Sleep -Seconds 1
Get-Service -ComputerName $Computername -Name "isirona deviceescort service" | Stop-Service -Force

###
logFile -Content "Stopped the services"


Start-Sleep -Seconds 5

###
logFile -Content "Starting the services"


Get-Service -ComputerName $Computername -Name "isirona deviceconx service" | Start-Service
Start-Sleep -Seconds 1
Get-Service -ComputerName $Computername -Name "isirona deviceescort service" | Start-Service


}


###
logFile -Content "Starting the script..."


if(testFilePath){

$computerList = Get-Content "C:\Temp\IsironaServiceRestart\Computers.txt"

#tests if the computer is online then runs the appropriate functions
foreach($machine in $computerList){

###
logFile -Content "starting the loop to restart the services"
logFile -Content "

Running on the machine $machine

"


if(Test-Connection -ComputerName $machine -Count 1){

###
logFile -Content "The machine is online"


    if(getService $machine){restartServices $machine}
}
else{

###
logFile -Content "The machine $machine is not online"

Write-Error "THE MACHINE $machine IS NOT ONLINE PLEASE VERIFY NETWORK CONNECTION"}
}

}
else{exit}

