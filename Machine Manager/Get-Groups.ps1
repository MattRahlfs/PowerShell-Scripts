Param (
[Parameter(Mandatory=$true)]
[string]$Name,

[Parameter(Mandatory=$true)]
[ValidateSet('Computer', 'User')]
[string[]]$ObjectType

)






if ($ObjectType -ne 'User'){Get-ADComputer -Identity $Name –Properties MemberOf | Select-Object -ExpandProperty MemberOf | 
Get-ADGroup -Properties name }



