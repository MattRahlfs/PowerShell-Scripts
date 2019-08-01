param (

$_computerName

)


Start-Process powershell.exe "-noexit enter-pssession $_computerName"
