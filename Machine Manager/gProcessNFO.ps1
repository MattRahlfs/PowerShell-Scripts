

Try{
If (Test-Connection -ComputerName $hosts -count 1 -quiet){

Write-Output "Successfully Connected to $hosts `n
Retreiving process's from $hosts"
Invoke-Command -ComputerName $hosts -scriptblock {Get-Process | Select ProcessName, ID, Description, CPU, Memory| Format-List | Format-Wide}

}
Else{Write-Output "Unable to connect to the machine"}
}
Catch {Write-Output "An error occured"}
