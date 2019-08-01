$ccmcachepath = "C:\Windows\ccmcache"

foreach($folder in Get-ChildItem $ccmcachepath){



if (Get-ChildItem -Path "$ccmcachepath\$folder" | where name -like "*.exe"){

Add-Content C:\Temp\



}



}

