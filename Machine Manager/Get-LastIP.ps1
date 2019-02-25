param(

$_computerName

)


$address = nslookup $_computerName

Write-Output $address