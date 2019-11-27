param(

$ComputerName

)


function test_Connection{

try{

if(& $PSScriptRoot\Get-MachineConnection $ComputerName){return $true}
else{return $false}

}
catch{

Write-Output "There was an issue connecting to the machine"
exit
}

}



function test_BGInfo{

try{

if((Test-Path -Path "\\$ComputerName\C$\Windows\Mercy\Maint\BGInfo") -and (Test-Path -Path "\\$ComputerName\C$\Windows\Mercy\Maint\BGInfo\wallpaper.bmp")){
    
return $true

}
else{return $false}

}
catch{Write-Output "unable to check the bginfo DIR"}


}


function replace_Wallpaper{

try{

Rename-Item -Path "\\$ComputerName\C$\Windows\Mercy\Maint\BGInfo\wallpaper.bmp" -NewName "wallpaper.old" -Force

Copy-Item -Path "$PSScriptRoot\images\wallpaper.bmp" -Destination "\\$ComputerName\C$\Windows\Mercy\Maint\BGInfo\" -Force

Copy-Item -Path "$PSScriptRoot\images\SetBGInfo - Shortcut.lnk" -Destination "\\$ComputerName\C$\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" -Force

}
catch{Write-Output "unable to change the files"}
}



if((test_Connection) -and (test_BGInfo)){
Write-Output "$ComputerName is online and the filesystem is accessable"
Write-Output "The BGinfo data is verified"

replace_Wallpaper

    

    }