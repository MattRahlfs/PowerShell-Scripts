$hosts = Read-Host -Prompt "`nEnter the computer name"

Try{
If (Test-Connection -ComputerName $hosts -count 1 -ErrorAction Stop){

Try{

Write-Output "Successfully Connected to $hosts `n
Retreiving adapter data..."
$writetofile = Invoke-Command -ComputerName $hosts -ScriptBlock{Get-CimInstance win32_networkadapterconfiguration | 
                                                              Where ipaddress -ne $null | Select description, 
                                                              macaddress, ipaddress | Format-List}
Write-Output "Successfully retrieved data `n 
Writing data to file..."


& "$PSscriptroot\logToFile.ps1" "C:\Machine_info\$hosts.txt" $writetofile

}

Catch {Write-Output "Error occured, could not retreive adapter info"}

}
}
Catch{Write-Output "Unable to connect to the machine"}
