param(

[switch]$List

)


$loop = $true





function list_Clipboard{


Get-Content C:\Temp\ClipboardHistory.txt | Write-Output
exit


}


if($List -ne $false){list_Clipboard}

do{


$Current_Clip = Get-Clipboard -Raw -Format Text -TextFormatType Text

Start-Sleep -Seconds 3

if((Get-Clipboard -Raw -Format Text -TextFormatType Text) -eq $Current_Clip){Write-Output "clipboard hasnt changed"}
else{ 

Write-Output "Clipboard changed"
(Get-Clipboard -Raw -Format Text -TextFormatType Text) | Out-File -FilePath C:\Temp\ClipboardHistory.txt -Append}

Start-Sleep -Milliseconds 250

}
until($loop=$false)