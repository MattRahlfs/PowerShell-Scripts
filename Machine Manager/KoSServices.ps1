
$loop = $true
Write-Output "`n"


While($loop -EQ $true){

Try{
    If(Test-Connection -ComputerName $hosts -Count 1 -TimeToLive 3 -Quiet){

       Write-Host -ForegroundColor Green "Menu"
       Write-Host -ForegroundColor Yellow "1. List Services `n2. Kill Services `n3. Start Servcices `n4. Search for services`n0. EXIT"
       $userinput = Read-Host -Prompt "Enter an option"

        If($userinput -EQ 1){

           
           $services = Get-Service -ComputerName $hosts | Where Status -EQ 'Running' |Select -ExpandProperty DisplayName
           $count = 0

           foreach($service in $services) {

                   $services[$count] = "$count. $service"
                   $count++}

           Write-Host -ForegroundColor Green "These are the running services`n"
           $services | Format-Wide {$_} -AutoSize -Force


           $services = Get-Service -ComputerName $hosts | Where Status -EQ 'Stopped' |Select -ExpandProperty DisplayName
           $count = 0

           foreach($service in $services) {

                   $services[$count] = "$count. $service"
                   $count++}

           Write-Host -ForegroundColor Red "These are the stopped services"
           $services | Format-Wide {$_} -AutoSize -Force
           pause

           }
        ElseIf($userinput -EQ 2){
                
               
               $userinput = Read-Host "Enter the service you want to kill"
               Invoke-Command -ComputerName $hosts -ArgumentList $userinput -ScriptBlock{param($userinput) Stop-Service -DisplayName $userinput -Force}
                }
        ElseIf($userinput -EQ 3){
                
               $userinput = Read-Host "Enter the service you want to start"               
               Invoke-Command -ComputerName $hosts -ArgumentList $userinput -ScriptBlock{param($userinput) Start-Service -DisplayName $userinput}
                }
        ElseIf($userinput  -EQ 4){
               
               $userinput = Read-Host "What service are you looking for"
               Invoke-Command -ComputerName $hosts -Argumentlist $userinput -ScriptBlock{param($userinput) Get-Service -DisplayName "*$userinput*"}
               }
        ElseIf($userinput -EQ 0){$loop = $false}

    }
    Else{Write-Host -ForegroundColor Red "Unable to connect to the computer $hosts" 
         $loop = $false
        }

}
Catch{Write-Host -ForegroundColor Red "Failed to run the services manager"
      $loop = $false
      }

}

