$firefox = Get-Process firefox -ErrorAction SilentlyContinue
$edge = Get-Process msedge -ErrorAction SilentlyContinue


if( $firefox -ne $null ) {
    1, 2, 4, 8, 16, 32, 64, 128 |
    Out-GridView -Title "Firefox ProcessorAffinity - Select Processors to use" -PassThru |
    ForEach-Object -Begin { $affi = 0 } {
        $affi += $_
    } -End { $firefox | ForEach-Object { $_.ProcessorAffinity = $affi } }
}

if( $edge -ne $null ) {
    1, 2, 4, 8, 16, 32, 64, 128 |
    Out-GridView -Title "MsEdge ProcessorAffinity - Select Processors to use" -PassThru |
    ForEach-Object -Begin { $affi = 0 } {
        $affi += $_
    } -End { $edge | ForEach-Object { $_.ProcessorAffinity = $affi } }
}