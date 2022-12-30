

function Lives ( $name ) {
    $name -in (Get-Process).ProcessName
}
$targets = @{
    firefox     = 128 + 64 + 32
    msedge      = 128 + 64 + 32
    explorer    = 128 + 64 + 32
}


$targets.Keys.ForEach{
    $pr_name = $_
    if ( Lives $pr_name ) {
        Get-Process $pr_name | ForEach-Object {
            $_.ProcessorAffinity = $targets.$pr_name
        }
    }    
}

        
