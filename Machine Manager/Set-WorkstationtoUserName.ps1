param(

$ComputerName

)




$serial = ($ComputerName = -split $ComputerName).Substring(1)

return "u$serial"
