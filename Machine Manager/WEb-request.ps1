    $URL2 = "http://patr/"
    $URL = "http://patr/misd/reports/Asset_Report.aspx"

   
    $cred = Get-Credential mrahlfs1

    $html = Invoke-WebRequest -Uri $URL -SessionVariable session -Method Post -Credential $cred
    $html.Forms[0].Fields['ctl00$Main$txtComp']="bgks6h2"

    $newURL = $URL2 + $html.Action

    $html2 = Invoke-WebRequest -Uri $newURL -WebSession $session -Method Post -Body $html -Credential $cred

    $html2.Content | Out-File c:\file1.txt 




$IE = New-Object -ComObject "Internetexplorer.Application"
$IE.Navigate('http://patr/misd/reports/Asset_Report.aspx')
$IE.Visible = $true
$Doc = $IE.Document
$clickserialradiobutton= $Doc.GetElementByID('ctl00_Main_rblChoice_1')
$clickserialradiobutton.Click()
$textfield = $Doc.getElementById('ctl00$Main$txtComp')
$textfield