param(

$Path,

$Age

)


Try{


Get-ChildItem -Path $Path | Where {$_.LastWriteTime -lt (Get-Date).AddDays(-$Age)} | Remove-Item -Force

}
Catch{$_.ErrorMessage
      Write-Output "Unable to remove old files"}