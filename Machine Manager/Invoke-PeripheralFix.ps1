param(

[parameter(Mandatory=$true)]
$_computerName,

[ValidateSet("Mouse")]
[String[]]
$_peripheralType


)


function checkOS{

if (Invoke-Command -ComputerName $_computerName -ScriptBlock {
(Get-WmiObject Win32_OperatingSystem).caption -like "*Windows 10*"}){

Write-Output "Computer is win10"

}
else{throw "its not win10"}


}

function disable_Device($_deviceObject){


Invoke-Command -ComputerName $_computerName -ArgumentList $_deviceObject -ScriptBlock{

param($_deviceObject)

Disable-PnpDevice ($_deviceObject).instanceid -Confirm:$false

}

}

function enable_Device($_deviceObject){


Invoke-Command -ComputerName $_computerName -ArgumentList $_deviceObject -ScriptBlock{

param($_deviceObject)

Enable-PnpDevice ($_deviceObject).instanceid -Confirm:$false

}

}


function get_Device{

Invoke-Command -ComputerName $_computerName -ArgumentList $_peripheralType -ScriptBlock {

param($_peripheralType)

Get-PnpDevice | where name -like "*$_peripheralType*" | where present -eq "true"  | where name -like "HID*" | select instanceID

}

}


try{

    if(& "$PSScriptRoot\Get-MachineConnection.ps1" $_computerName){

    Write-Output "connected"
    }
    else {throw "Not connected"}
   
    

}
catch{

Write-Output "Cannot connect to the computer $_computerName"
exit

}


try{checkOS}
catch{Write-Output "The computer is not win10"
exit}






$_deviceObject = get_Device
Write-Output "The deviceID is: $(($_deviceObject).instanceID)"
try{

disable_Device($_deviceObject)
Write-Output "disabled the device"

}
catch{write-out "unable to disable the device"
exit}

Start-Sleep -Seconds 5

Write-Output "waiting for 5 seconds"

try{

enable_Device($_deviceObject)
Write-Output "enabled the device"

}
catch{Write-Output "unable to enable the device"
exit}

