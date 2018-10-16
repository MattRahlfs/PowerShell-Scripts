
param (

$ComputerName

)
 

 If(Test-connection -ComputerName $ComputerName -count 1 -ErrorAction Stop){


Invoke-Command -ComputerName $ComputerName -ScriptBlock {Get-Process | where processname -like "ICUMonitor" | Stop-Process -Force}

Write-Host "Killed the ICUmonitor EXE so the file copy can complete"

Remove-Item -Path "\\$ComputerName\C$\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\ICU*" -Force 

Write-Host "Removed the .lnk so the copy of the shortcut can complete."

Copy-Item -path "\\mercyhome\hm\mrahlfs1\Epic Monitor Files\ICUMonitor.lnk" -Destination "\\$ComputerName\C$\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\" -Force

Write-Host "Copied the shortcut to the machine startup folder for all users"

Write-Host "Started job to copy the files into the v8.3 directory (monitor)"

Start-Job -Name "CIM $ComputerName" -ArgumentList $ComputerName -ScriptBlock {param($ComputerName) Copy-Item -Path "\\mercyhome\hm\mrahlfs1\Epic Monitor Files\Single Room\Monitor" -Destination "\\$ComputerName\C`$\Program Files (x86)\Epic\v8.3" -Recurse -Force}


}


Else{Write-Host "Failed to connect to the machine"}



<#
 
 
 Copy-Item -Path "\\mercyhome\hm\mrahlfs1\Epic Monitor Files\Single Room\Monitor" -Destination "\\$ComputerName\C`$\Program Files (x86)\Epic\v8.3" -Recurse -Force

 Write-Host "Copying" -NoNewline
do{

Write-Host "." -NoNewline
Start-Sleep -Seconds 30 
}
Until(

Get-Job | Where name -like "Testing" | Where state -like "Completed"

)

$wshell = New-Object -ComObject Wscript.Shell

$wshell.Popup("Operation Completed",0,"Done",0x1)

Remove-Job -Name "Copy*"

}


#>
