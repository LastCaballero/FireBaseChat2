Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = [System.Windows.Forms.Form]::new()
$form.Text = "Power-Setter"
$form.Size = [System.Drawing.Size]::new(500,200)

$label = [System.Windows.Forms.Label]::new()
$label.Text = $( powercfg /getactivescheme )
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
            $label.Text = $( powercfg /getactivescheme )
        }
        {$_ -eq 1} {
            powercfg /setactive scheme_balanced
            $label.Text = $( powercfg /getactivescheme )
        }
        {$_ -eq 2} {
            powercfg /setactive scheme_min
            $label.Text = $( powercfg /getactivescheme )
        }
    }
})



$form.Controls.AddRange(@($combo, $label))
$form.ShowDialog()