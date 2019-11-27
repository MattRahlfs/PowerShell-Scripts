param(

[Parameter(Mandatory=$true)]
$URL,

[Parameter(Mandatory=$true)]
$Path,

[Switch]
$OFL

)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12





(New-Object System.Net.WebClient).DownloadFile($URL, $Path)

if($OFL){explorer.exe "$Path"}

