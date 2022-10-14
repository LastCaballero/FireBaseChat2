Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function actual_scheme_id {
    (powercfg /getactivescheme) -match "\w+-\w+-\w+-\w+-\w+" > $null
    $Matches[0]
}

function actual_scheme_name {
    (powercfg /getactivescheme) -match "\(.+\)" > $null
    $Matches[0] -replace "\(|\)",""
}

$form = [System.Windows.Forms.Form]::new()
$form.Text = "Power-Setter"
$form.Size = [System.Drawing.Size]::new(500,200)

$label = [System.Windows.Forms.Label]::new()
$label.Text = actual_scheme_name
$label.Width = 300
$label.Height = 150
$label.Location = [System.Drawing.Point]::new(50,100)

$combo = [System.Windows.Forms.ComboBox]::new()
$combo.AutoSize = $true
$combo.items.AddRange(@("save energy","balanced", "power"))
$combo.Location = [System.Drawing.Point]::new(50,50)
$combo.add_SelectedIndexChanged({
    $selection = $combo.SelectedIndex
    switch ( $selection ) {
        {$_ -eq 0} { 
            powercfg /setactive scheme_max
            $label.Text = actual_scheme_name
        }
        {$_ -eq 1} {
            powercfg /setactive scheme_balanced
            $label.Text = actual_scheme_name
        }
        {$_ -eq 2} {
            powercfg /setactive scheme_min
            $label.Text = actual_scheme_name
        }
    }
})

$form.Controls.AddRange(@($combo, $label))
$form.ShowDialog()