param(

[string[]]$ComputerName,
[string]$Name,
[string]$EXEpath,
[string]$ShortcutPath,
[string]$destination

)


function convert_pc_U {

$pcnow = $ComputerName.Substring(1)
$pcu = "u" + $pcnow

return $pcu


}

function create_symlink{

$uaccount = convert_pc_U

$StartupFolder = "C:\Users\$uaccount\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

foreach($Computer in $ComputerName){


if(Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue){

Invoke-Command -ComputerName $computer -ArgumentList $EXEpath, $Name -ScriptBlock{

param (
$StartupFolder,
$EXEpath,
$Name
)


New-Item -ItemType SymbolicLink -Path $StartupFolder -Name "$Name.lnk" -Value $EXEpath 

}

}
Else{Write-Host "Couldnt connect to $computer"}

}
}

function copy_shortcut{

$uaccount = convert_pc_U


if(Test-Path -Path $ShortcutPath){

foreach ($computer in $ComputerName){


Copy-Item -Path $ShortcutPath -Destination "\\$computer\C$\users\$uaccount\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"


}

}
else{"that shortcut path is not valid"}


}


if($ShortcutPath -ne $null){copy_shortcut}
elseif($EXEpath -ne $null){create_symlink}