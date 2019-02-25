

param (

[string[]]$ComputerName,

[switch]$L

)




function test_Connection {


If((Test-Connection -ComputerName $ComputerName -Count 1 -ErrorAction SilentlyContinue)){
   
   If(Invoke-Command -ComputerName $ComputerName -ScriptBlock {Test-Path -Path "C:\Windows\System32\svchost.exe"} ){
      
      if($L -eq $true){Write-Host -ForegroundColor Green "`nThe Filesystem is available, the computer is online"}

      return $true
     }
}else{return $false}

}


test_Connection