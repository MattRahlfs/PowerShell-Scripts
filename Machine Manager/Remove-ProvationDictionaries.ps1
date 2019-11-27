
param($computerName)

try{

if(Test-Connection -ComputerName $ComputerName -Count 1){
     Remove-Item "\\$computername\c$\ProgramData\Mercy\App\WoltersKluwer_ProvationMD\Provation Medical" -Force  

    }

}

catch{
Write-Output "there was an error"
}
