Param(


$Path,

[Parameter(Mandatory=$true)]
[ValidateSet('Floor 2', 'Floor 3', 'Floor 4', 'Floor 5', 'Floor 6')]
[string[]]$Floor, 


[ValidateSet('A', 'AB', 'B', 'c', 'D', 'E')]
[string[]]$Quad, 

[string]$Room,

[switch] $List

)


class assets {


[string]$Floor
[string]$Quad
[string]$Room
[array]$assets


}


function printassets{

Param(

$Assets
)

Write-Host "`r"
Write-Host -ForegroundColor Green "*****"
Write-Host "`r"

Write-Output $Assets.Floor

Write-Host -NoNewline "Quad: "
Write-Output $Assets.Quad

Write-Host -NoNewline "Room: "
Write-Output $Assets.Room

Write-Host "`r"

Write-Output $Assets.Assets

Write-Host "`r"
Write-Host -ForegroundColor Green "*****"
Write-Host "`r"
}



function getassets{


$roomAssets = New-Object assets




$roomAssets.Floor=$Floor
$roomAssets.Quad=$Quad
$roomAssets.Room=$Room
$roomAssets.Assets=(Get-Content -Path "$Path\$Floor\Hallway $Quad\$Room")
printassets ($roomAssets)
}


function listgroup{

foreach ($Room in (Get-ChildItem -Path "$Path\$Floor\Hallway $Quad")){

getassets($Room | select -ExpandProperty name)

}

}


if ($List -ne $false){listgroup}
elseif($Room -ne $null){

    if($Room -like "*.txt"){
       getassets}
    else{
        $Room = $Room + ".txt"
        getassets}
}