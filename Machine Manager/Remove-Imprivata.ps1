<#

.SYNOPSIS
    Removes Imprivata from a remote machine
.EXAMPLE
    Remove-Imprivata -Type Appstation
.EXAMPLE
    Remove-Imprivata -Type Workstation   
.DESCRIPTION
    This script runs the uninstall script for imprivata on a remote machine. The script is located in the parent
    directory C:\Windows\ccmcache of the machine you are uninstalling from. The script changes whether appstation
    or workstation is installed. This script takes input, if the computer is appstation or workstation. Then 
    finds the full path for the script and runs ths script on the remote machine. It then waits a period of time
    and restarts the remote computer.
#>

Param (
[Parameter(Mandatory=$true)]
[string]$ComputerName,

[Parameter(Mandatory=$true)]
[ValidateSet('Appstation', 'Workstation')]
[string]$Type

)

#this is the directory where sccm caches .exe and .mst files for installation /uninstall
$ScriptPath = "C:\Windows\ccmcache"

<#using invoke-command to send commands to a remote machine, depending if appstation or workstation was selected
it will retrieve the path for the respective uninstall script. When the right script is found it will launch the script on
the remote machine. 
#>
Invoke-Command -ComputerName $ComputerName -ArgumentList $ScriptPath, $Type -ScriptBlock {

param($ScriptPath, $Type)

$appstationpath = Get-ChildItem -Path $ScriptPath -Filter "Uni-ImprivataAgentforAppStation*" -Recurse -Force | select -ExpandProperty FullName
$workstationpath = Get-ChildItem -Path $ScriptPath -Filter "Uni-ImprivataAgentforRegular*" -Recurse -Force | select -ExpandProperty FullName

if($Type -eq "Appstation"){& $appstationpath}
elseif($Type -eq "Workstation"){& $workstationpath}

} -ErrorAction SilentlyContinue

#when the script completes this script pauses for 5 seconds to give it a moment to exit cleanly and then restarts the computer
Start-Sleep -Seconds 5

Restart-Computer -ComputerName $ComputerName -Force




