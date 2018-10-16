

param (

[string[]]$ComputerName,

[switch]$L

)


for($timer=$null; $timer-lt100){

If((Test-Connection -ComputerName $ComputerName -Count 1 -ErrorAction SilentlyContinue)){
   
   If(Invoke-Command -ComputerName $ComputerName -ScriptBlock {Test-Path -Path "C:\Windows\System32\svchost.exe"} -ErrorAction SilentlyContinue){
      
      if($L -eq $true){Write-Host -ForegroundColor Green "`nThe Filesystem is available, the computer is online"}

      return $true
      $timer=100}
   Else{Write-Host -ForegroundColor Red -BackgroundColor White "." -NoNewline
        $timer++}
   }
Else{Write-Host -ForegroundColor Red -BackgroundColor White "." -NoNewline
$timer++}


}


