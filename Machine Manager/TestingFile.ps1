
$path1 = "C:\temp\testinglog1.txt"


Start-Transcript -Path $path1 -Verbose

$path = "C:\temp\testinglog.txt"

& "$PSScriptRoot\logToFile.ps1" -path $path -content "before the job"



start-job -Name jobfortesting -Credential mrahlfs1 -ScriptBlock {

& "$PSScriptRoot\logToFile.ps1" -path $path -content "in the job"
$date = Get-Date

$date | Out-File -FilePath $path -Append


}
get-job



& "$PSScriptRoot\logToFile.ps1" -path $path -content "after the job"


wait-job -Name jobfortesting 

get-job -Name jobfortesting | Remove-Job


write-host "stuff"

Get-Job


Stop-Transcript
<#
wait-job -Name jobfortesting 

get-job -Name jobfortesting | Remove-Job




$afterthejob

$afterthejob=Get-ADUser -Identity mrahlfs1 

$afterthejob | Out-File -FilePath C:\users\mrahlfs1\testinglog.txt -Append




start-job -Name jobfortesting -ScriptBlock {

& "$PSScriptRoot\logToFile.ps1" -path "C:\IPER LOG.txt" -content "inth e job"
$date = Get-Date

$date | out-file -FilePath C:\testinfile.txt -Append












#>