param (


$_computerName
)

function enableRemoteControl{

Try{

Invoke-Command -ComputerName $_computerName -ScriptBlock{

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SMS\Client\Client Components\Remote Control" -Name "Permission Required" -Value 0
Start-Sleep -Seconds 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SMS\Client\Client Components\Remote Control" -Name "Enabled" -Value 1

}


}
Catch{

Write-Output "BAD MESSAGE"

}


}


enableRemoteControl