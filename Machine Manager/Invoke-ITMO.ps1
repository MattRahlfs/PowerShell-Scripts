param (


 $computername

 )

 $start=Get-Date

  Try{
  
  
  do{
    
    if(Test-Connection -ComputerName $computername -Count 1 -ErrorAction Ignore){return $true}
        Start-Sleep -Seconds 1}

  until((get-date) -gt ($start.AddMinutes(10)))

  if((get-date) -gt ($start.AddMinutes(10))){return $false}




  }

  Catch{return $false}