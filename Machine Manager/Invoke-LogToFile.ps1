

param(

 $Path = "c:\Log-ToFile.txt",

 $Content = ""
 
 )



Write-Output "
~ ~ ~ ~ ~ ~ ~ $(Get-Date -UFormat '%m/%d/%Y %T') ~ ~ ~ ~ ~ ~ ~ 
" | Out-File -Append -FilePath "$Path"



$Content | Out-File -Append -FilePath "$Path"

Write-Output "################################################ "| Out-File -Append -FilePath "$Path"
