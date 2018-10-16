param(

$ComputerName

)



Try{

    if(& "$PSScriptRoot\itmo.ps1" $ComputerName){

        Invoke-Command -ComputerName $ComputerName -ScriptBlock {

  
        
            $AdapterInfo = @{}    
            $Command = Get-NetAdapter| where status -EQ "up"

          
       
            $AdapterInfo.MAC = $Command | select -ExpandProperty MacAddress

            $AdapterInfo.Name = $Command | select -ExpandProperty Name 

            $AdapterInfo.Description = $Command | select -ExpandProperty InterFaceDescription 

            $AdapterInfo.IPAddress = Get-NetIPAddress | where InterfaceAlias -eq "$($AdapterInfo.name)" | 
                select -ExpandProperty IPAddress

              
            $AdapterInfo
       
        }

    }else {Write-Output "`nFailed to connect to $ComputerName"}


}
Catch{Write-Output "Something Failed"}