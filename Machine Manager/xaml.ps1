$inputXML = Get-Content "$PSScriptRoot\gui.xaml"

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
}
catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties in your textboxes (PowerShell cannot process them)"
    throw
}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
  
$xaml.SelectNodes("//*[@Name]") | %{
    try {Set-Variable -Name "$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }

########################
#Manipulate the XAML
########################

$bSubmit.Content = "This Button"
$lLabel.Content = "Ehhhh"
$tbUsername.Text = "UserName"

########################
#Add Event Handlers
########################

$bSubmit.Add_Click({
    
    if ($tbUsername.Text -ne "" -and $tbUsername.Text -ne "UserName" -and $pbPassword.Password -ne "") {

        $lLabel.Content = "You pressed the button."

        }

    })

#Show the Form
$form.ShowDialog() | Out-Null