param(

$computername

)


$ScriptRoot = $PSScriptRoot
$ScriptRoot

Start-Sleep -Seconds 30
$starttime = Get-Date



do{

    if(Test-Connection -ComputerName $computername -Count 1 -Quiet){
        if(Get-Process -ComputerName $computername -Name "CmRcService"){
            "the computer is online and the process exists"
            & $ScriptRoot\Invoke-AlertNoise.ps1
            & $ScriptRoot\Invoke-FormAlert.ps1 "$computername is online, and the CCM service is running"
            exit
            }
        }

}
until((Get-Date) -ge $starttime.AddSeconds(5))




<#
do{



if(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet){
    if(Get-Process -ComputerName $ComputerName | where name -like "CmRcService"){
        & "$ScriptRoot\Invoke-AlertNoise.ps1"
        & "$ScriptRoot\Invoke-FormAlert.ps1" "$ComputerName is online and the CmRcService is running."
        exit
        }else{Start-Sleep -Seconds 30}

}

}
until((Get-Date) -ge $starttime.AddSeconds(5))


#>