param($message)

function display_Form($message){




Add-Type -AssemblyName System.Windows.Forms
$Form = New-Object system.Windows.Forms.Form

$Form.Text = "CCM Service Alert"



$Label = New-Object System.Windows.Forms.Label
$Label.Text = "$message"
$Font = New-Object System.Drawing.Font("Arial",20,[System.Drawing.FontStyle]::Bold)
$Form.Font = $Font
$Label.ForeColor = "green"
$Form.AutoSize = $True
$Label.AutoSize = $True
$Form.AutoSizeMode = "GrowAndShrink"

$Form.Controls.Add($Label)

$Form.MinimizeBox = $False

$Form.MaximizeBox = $False

$Form.StartPosition = "CenterScreen"
$Form.Topmost = $True
$Form.ShowDialog() 

}


display_Form($message)