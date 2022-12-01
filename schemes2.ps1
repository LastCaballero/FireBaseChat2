Add-Type -AssemblyName System.Windows.Forms

$form = [System.Windows.Forms.Form]@{ 
    Width = 300
}


$label = [System.Windows.Forms.Label]@{
    Text = ((Invoke-Expression "powercfg /getactivescheme") -split " +")[-1]
    TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    Width = 290
}

function SetText {
    $label.Text = ((Invoke-Expression "powercfg /getactivescheme") -split " +")[-1]
}

$save = [System.Windows.Forms.Button]@{ Text = "Save" }
$medium = [System.Windows.Forms.Button]@{ Text = "Medium" }
$power = [System.Windows.Forms.Button]@{ Text = "Power" }

$save.Add_Click( { Invoke-Expression "powercfg /setactive scheme_max"; SetText } )
$medium.Add_Click( { Invoke-Expression "powercfg /setactive scheme_balanced"; SetText } )
$power.Add_Click( { Invoke-Expression "powercfg /setactive scheme_min"; SetText } )

$panel = [System.Windows.Forms.TableLayoutPanel]::new()
$panel.RowCount = 2
$panel.ColumnCount = 3
$panel.AutoSize = $true


$panel.Controls.Add( $save )
$panel.Controls.Add( $medium )
$panel.Controls.Add( $power )
$panel.Controls.Add( $label )
$panel.SetColumnSpan( $panel.Controls[3], 3 )

$form.Controls.Add( $panel )

$form.ShowDialog()