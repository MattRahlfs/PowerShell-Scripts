

function checkosversion {

param (

$computername
)

if (Get-ADComputer $computername -Properties operatingsystem | where operatingsystem -like "*10*" | select -ExpandProperty operatingsystem){"computer is win10"


if(checkforpolicy -computername $computername -eq $true){"this computer is win10 and has a policy set"}
else{"$computername" | Out-File -FilePath C:\cwip.txt -Append}


}
elseif(Get-ADComputer $computername -Properties operatingsystem | where operatingsystem -like "*7*" | select -ExpandProperty operatingsystem){"computer is win7"



if(checkforinstall -computername $computername -eq $true){

if(checkforpolicy -computername $computername -eq $true){"this computer is win7 and has a policy set"}
else{"$computername" | Out-File -FilePath C:\cwip.txt -Append}

}
else{"imprivata is not installed"}



}

}

function checkforinstall {

param(

$computername
)


if (Get-ADComputer $computername -Properties memberof | select -expandproperty memberof | Get-ADGroup -Properties name | where name -like "*ImprivataAgentforRegular*"){return $true}
elseif(Get-ADComputer $computername -Properties memberof | select -expandproperty memberof | Get-ADGroup -Properties name | where name -like "*ImprivataAgentforAppStation*"){return $true}
else{return $false}


}


function checkforpolicy {

param(

$computername

)

if (Get-ADComputer $computername -Properties memberof | select -expandproperty memberof | Get-ADGroup -Properties name | where name -like "*Imprivata.Hospital_Appstation*"){return $true}
elseif (Get-ADComputer $computername -Properties memberof | select -expandproperty memberof | Get-ADGroup -Properties name | where name -like "*imprivata.mercy_workstations*"){return $true}
elseif(Get-ADComputer $computername -Properties memberof | select -expandproperty memberof | Get-ADGroup -Properties name | where name -like "*Imprivata.CLN_Appstation*"){return $true}
elseif(Get-ADComputer $computername -Properties memberof | select -expandproperty memberof | Get-ADGroup -Properties name | where name -like "*imprivata.SAMC.Surgical Suite*"){return $true}
elseif(Get-ADComputer $computername -Properties memberof | select -expandproperty memberof | Get-ADGroup -Properties name | where name -like "*Imprivata_Uni_W10*"){return $true}
else{return $false}



}



foreach($computer in (Get-Content 'C:\users\mrahlfs1\OneDrive - Mercy Online\machines in okc campus.txt')){

"$computer"



checkosversion -computername $computer


}


