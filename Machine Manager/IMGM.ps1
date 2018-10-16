# paramaters to get floor and room number and or department and hallway
param (

$Floor, 

$Hall,

$Room, 

$Department,

[string[]]$Assets

)

$MainPath = "C:\Users\mrahlfs1\OneDrive - Mercy Online"

If(!(Test-Path -Path "$MainPath\IMGM")){New-Item -Path "$MainPath" -ItemType Directory -Name IMGM}

#make sure there is a folder for each floor and department and hallway






for($i=2; $i -le 6; $i++){

If(!(Test-Path -Path "$MainPath\IMGM\Floor $i")){

New-Item -Path "$MainPath\IMGM\" -Name "Floor $i" -ItemType Directory
}

}


If(!(Test-Path -Path "$MainPath\IMGM\Floor $Floor\Hallway $Hall")){

New-Item -Path "$MainPath\IMGM\Floor $Floor" -Name "Hallway $Hall" -ItemType Directory


}



If(!(Test-Path -Path "$MainPath\IMGM\Floor $Floor\Hallway $Hall\Room $Room")){



 $null | Out-File -FilePath "$MainPath\IMGM\Floor $Floor\Hallway $Hall\$Room.txt" 

}


If($Assets -eq $null){

If(!(Test-Path -Path "C:\Users\mrahlfs1\Desktop\IMGM.txt")){Write-Host "Either enter the assets through the -assts switch or enter each asset on a new line in the file $ENV:USERPROFILE\Desktop\IMGM.txt"
}
ElseIf((Test-Path -Path "C:\Users\mrahlfs1\Desktop\IMGM.txt")){(Get-Content -Path "C:\Users\mrahlfs1\Desktop\IMGM.txt")  | Out-File "$ENV:USERPROFILE\IMGM\Floor $Floor\Hallway $Hall\$Room.txt"
}

}
ElseIF($Assets -ne $null){$Assets | Out-File "$MainPath\IMGM\Floor $Floor\Hallway $Hall\$Room.txt"}











