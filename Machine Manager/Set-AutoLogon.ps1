param(


$ComputerName,

[Parameter(Mandatory=$true,
HelpMessage="Enter any character for yes or press enter for no.")]

$Remove = $null,

[Parameter(Mandatory=$true)]
[ValidateSet("7","10")]
$OS

)

& "$PSScriptRoot\Invoke-RemoveOldData.ps1" "C:\Windows\Mercy\Set-AutoLogon-log*" 7

$invokeLogFile = "$PSScriptRoot\Invoke-LogToFile.ps1"
$logPath = "C:\Windows\Mercy\Set-AutoLogon-log $(Get-Date -UFormat '%m%d%y').txt"

& $invokeLogFile $logPath "Starting the Set-AutoLogon Script"

$Main_Location = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\"

$Paths = @{

Main_Value = 'AutoAdminLogon'

UserName = 'DefaultUserName'

Password = 'DefaultPassword'

}


function test_Path_Connection{

& $invokeLogFile $logPath "Starting the test_Path_Connection funtion"

Try{
        
    if(& "$PSScriptRoot\Get-MachineConnection.ps1" $ComputerName){


       & $invokeLogFile $logPath "Successfully verified the computer is on the network, starting to invoke-command"

       $path_Test_Var =  Invoke-Command -ComputerName $ComputerName -ArgumentList $Main_Location, $Paths -ScriptBlock {

            param(

            $Main_Location,

            $Paths

                )

            

                    Try{

                        if(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\' | 
                            select -ExpandProperty $Paths['Main_Value'] -ErrorAction stop){return $true}

                        }
                    Catch{return $false}


                        


}

       & $invokeLogFile $logPath "The return Value is $path_Test_Var"

       return $path_Test_Var

       
      
        

     }
     else{Write-Output "Unable to connect to the computer $ComputerName"
          & $invokeLogFile $logPath "The computer was not reachable over the network"}
    
    }
    Catch{$_.ErrorMessage
          Write-Output "Unable to Test the connection or paths"
          & $invokeLogFile $logPath "Unable to Continue after the script was unable to reach the computer over the network"}

}


function test_AD_Group{

& $invokeLogFile $logPath "Starting the test_AD_Group function"

$uaccountVar = & "$PSScriptRoot\Set-WorkstationtoUserName.ps1" $ComputerName

if(Get-ADComputer -Identity $ComputerName –Properties MemberOf | 
    Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | 
            where name -Like "*AutoLoginCheck*" | select name){Write-Output "$ComputerName is in the AD group"
                                                                      & $invokeLogFile $logPath "The computer is in the AD Group"}
elseif(!(Get-ADComputer -Identity $ComputerName –Properties MemberOf | 
            Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | 
                where name -Like "*AutoLoginCheck*" | select name)){Write-Output "$ComputerName is not in the AD group"
                                                                           & $invokeLogFile $logPath "The Computer is not in the AD Group"}

if(Get-ADUser -Identity $uaccountVar -Properties MemberOf | 
    select -ExpandProperty memberof | Get-ADGroup -Properties name | 
        where name -like "*appstation*" | select name){Write-Output "$uaccountVar has appstation groups assigned"
                                                            & $invokeLogFile $logPath "user account is in appstation groups"}
elseif(!(Get-ADUser -Identity $uaccountVar -Properties MemberOf | 
    select -ExpandProperty memberof | Get-ADGroup -Properties name | 
        where name -like "*appstation*" | select name)){Write-Output "$uaccountVar does not have appsation groups assigned"
                                                            & $invokeLogFile $logPath "user account is not in the appstation groups"}


}


function setAutoLogon7{


& $invokeLogFile $logPath "Setting the registry values to allow auto login"
Try{

$uaccountVar = & "$PSScriptRoot\Set-WorkstationtoUserName.ps1" $ComputerName

& $invokeLogFile $logPath "Created the U account"
& $invokeLogFile $logPath "Starting the invoke-command"

Invoke-Command -ComputerName $ComputerName -ArgumentList $Main_Location, $Paths, $uaccountVar -ScriptBlock {

param(

$Main_Location,

$paths,

$uaccountVar


)



Set-ItemProperty -Path $Main_Location -Name $Paths['Main_Value'] -Value 1
Set-ItemProperty -Path $Main_Location -Name $Paths['UserName'] -Value $uaccountVar
Set-ItemProperty -Path $Main_Location -Name $Paths['Password'] -Value '$omeTh1ng3lsE'






}   

}
Catch{Write-Output "Unable to set the keys required for AutoLogon on $ComputerName"
$_.ErrorMessage

}


}




function setAutoLogon10{


& $invokeLogFile $logPath "Setting the registry values to allow auto login"
Try{


Invoke-Command -ComputerName $ComputerName -ArgumentList $Main_Location, $Paths, $uaccountVar -ScriptBlock {

param(

$Main_Location,

$paths,

$uaccountVar


)


Set-ItemProperty -Path $Main_Location -Name $Paths['Main_Value'] -Value 1

}

}
Catch{Write-Output "Unable to set the keys required for AutoLogon on $ComputerName"
$_.ErrorMessage

}


}

function removeAutoLogon7{


Try{

Invoke-Command -ComputerName $ComputerName -ArgumentList $Main_Location, $Paths -ScriptBlock {

param(

$Main_Location,

$Paths


)



Remove-ItemProperty -Path $Main_Location -Name $Paths['Main_Value'] -Force
Remove-ItemProperty -Path $Main_Location -Name $Paths['UserName'] -Force
Remove-ItemProperty -Path $Main_Location -Name $Paths['Password'] -Force






}

}
Catch{Write-Output "Unable to remove AutoLogon"
$_.ErrorMessage}




}

function removeAutoLogon10{



Try{

Invoke-Command -ComputerName $ComputerName -ArgumentList $Main_Location, $Paths -ScriptBlock {

param(

$Main_Location,

$Paths


)



Set-ItemProperty -Path $Main_Location -Name $Paths['Main_Value'] -Value 0







}

}
Catch{Write-Output "Unable to remove AutoLogon"
$_.ErrorMessage}


}



Write-Host "`n"


if($OS -eq 7){


if($Remove -and (test_Path_Connection)){Write-Output "Removing Auto Logon from $ComputerName" 
                removeAutoLogon7
                    & $invokeLogFile $logPath "Removed autologin from the machine"}
elseif (!(test_Path_Connection)){Write-Output "Auto Logon is not set on this computer"
                                    setAutoLogon7
                                        & $invokeLogFile $logPath "AutoLogon has finished"}
elseif(test_Path_Connection){Write-Output "Auto Logon is already set on this computer"}

test_AD_Group

}
elseif($OS -eq 10){


if($Remove -and (test_Path_Connection)){Write-Output "Removing Auto Logon from $ComputerName" 
                removeAutoLogon10
                & $invokeLogFile $logPath "Removed autologin from the machine"}
elseif (!(test_Path_Connection)){Write-Output "Auto Logon is not set on this computer"
                                    setAutoLogon10
                                    & $invokeLogFile $logPath "AutoLogon has finished"}
elseif(test_Path_Connection){Write-Output "Auto Logon is already set on this computer"}






}



