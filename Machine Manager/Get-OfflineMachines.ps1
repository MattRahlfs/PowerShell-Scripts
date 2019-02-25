param(

$Path,

$Destination

)


foreach($Computer in (Get-Content -Path $Path)){


if(Test-Connection -ComputerName $Computer -Count 1){

    Write-Output "$computer is online"
}

else{

$computer | Out-File -FilePath $Destination -Force
}

}