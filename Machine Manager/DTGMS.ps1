


#create the directory structure for the program 

#create the main folder

Send-MailMessage -to matthew.rahlfs@mercy.net -From PowershellScripts@mercy.net -Body "Filler Text" -Subject "DTMS Ran today" -SmtpServer smtp.mercy.net

If(!(Test-Path -Path C:\GMS\)){


New-Item -Path C:\ -Name GMS -ItemType Directory -Force

}
#create the main machine name file
If(!(Test-Path -Path C:\GMS\Main.txt)){

New-Item -Path C:\GMS -Name Main.txt -ItemType File -Force

}
#create the offline machines file
If(!(Test-Path -Path C:\GMS\OfflineMachines.txt)){

New-Item -Path C:\GMS -Name OfflineMachines.txt -ItemType File -Force

}


#use the main machine names and test who is online and offline


$Machines = Get-Content -Path C:\GMS\Main.txt


foreach ($Computer in $Machines){


#if job count is less than 10 proceed 
if((Get-Job -State Running).Count -ge 10){(Get-Job -State Running | Wait-Job -Any)}

Start-job -Name $Computer -ArgumentList $Computer -ScriptBlock{ param($Computer)

#tests if the name is in the DNS server
If(Resolve-DnsName -Name $Computer -ErrorAction SilentlyContinue){
#tests if the compute ris online
If(Test-Connection -ComputerName $Computer -Count 1 -ErrorAction SilentlyContinue){

#connects to the computer and gets the serial number If it finds one that matches it will send an email 
Invoke-Command -ComputerName $Computer -ScriptBlock {


$Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi

ForEach ($Monitor in $Monitors){

    $SerialList = "CN0524N3742614C27KTU","CN0KH0NGQDC0074L1VGB","CN0KH0NG7426169O2CWL","CN0KH0NG742616C17CPB","CN0FMXNRTV2007BS4F4B"
	
	$Serial = ($Monitor.SerialNumberID -notmatch 0 | ForEach{[char]$_}) -join ""

    #check if the last 7 characters of the serial number match
    foreach($SerialNumber in $SerialList){

    If(($Serial.substring($serial.length -7) -like ($SerialNumber.substring($SerialNumber.length -7)))){ 
           
        Send-MailMessage -To matthew.rahlfs@mercy.net -From PowershellScripts@mercy.net -Body "Found a match for a missing monitor `n`n$env:COMPUTERNAME, $Serial" -Subject "DTGMS Report" -SmtpServer  smtp.mercy.net 

        }
  }

    }

}

}#if the name is in the DNs but is offline move to this file
Else{$Computer | Out-File -FilePath C:\GMS\OfflineMachines.txt -Append}

}#if the machine is not in DNs move to this file
Else{$Computer | Out-File -FilePath C:\GMS\CannotResolve.txt}
}


}


