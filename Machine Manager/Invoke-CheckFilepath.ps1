param (

$computers, 

$filepath

)

foreach($pc in $computers){




if(Get-Item "\\$filepath"){


"$pc has the file $filepath"



}
else{"$pc does not have that file"}

}