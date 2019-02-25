
function kill_Zebra_Util{



try {

if(Get-Process -Name PrnUtils -ErrorAction stop){

Stop-Process -Name PrnUtils -Force

}
else{}

}
catch{

Write-Output "`nunable to find and stop the process for Zebra Setup Utility`r"
$_.Exception.Message

}

try{

if((Get-Service -Name Spooler | select -ExpandProperty status) -eq 'running'){

Start-Job -Name "Stopping spooler for zebra" -ScriptBlock {Stop-Service -Name Spooler -Force} 

}

}
catch{

Write-Output "`nunable to find and stop the spooler service`r"
$_.Exception.Message

}

try{

Wait-Job -Name "Stopping spooler for zebra"

Start-Service -Name Spooler

Start-Process -FilePath 'C:\Users\mrahlfs1\Desktop\Zebra Setup Utilities.lnk'


}
catch{

Write-Output "`nunable to start the service and the proccess`r"
$_.Exception.Message

}



}

kill_Zebra_Util

Remove-Job -Name "stopping spooler for zebra" -Force
