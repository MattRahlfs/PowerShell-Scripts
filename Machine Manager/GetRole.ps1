Param(

$ComputerName

)


$CRole = Get-ADComputer -Identity $ComputerName  -Properties MemberOf | Select -ExpandProperty MemberOf | Get-ADGroup -Properties Name | where Name -Like "Res-WKS-GPO*" | where Name -NotLike "*MBAM*"  | select -ExpandProperty Name

if($CRole -eq "Res-WKS-GPO-AppStation"){
    Write-Host "This Machine is an Appstation"
    }
elseif($CRole -eq "Res-WKS-GPO-LightlyManaged"){
    Write-Host "This Machine is a Workstation"
    }
elseIf ($CRole -eq "Res-WKS-GPO-Mobile"){
    Write-Host "This Machine is Mobile"
    }
