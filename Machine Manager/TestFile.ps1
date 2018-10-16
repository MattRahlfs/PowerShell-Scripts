do{


$previousX = $X

$previousY = $y


$X = [System.Windows.Forms.Cursor]::Position.X
$Y = [System.Windows.Forms.Cursor]::Position.Y




$newX = get-random -Minimum ($x-1) -Maximum ($x+1)
$newY = get-random -Minimum ($y-1) -Maximum ($y+1)





if(($previousX -lt $X+1) -or ($previousX -gt $X-1)){Write-Output "doing nothing"}
else{

[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($newX, $newY)


}




}
while($true)



