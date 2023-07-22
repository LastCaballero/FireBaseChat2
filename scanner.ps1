param (
    [Parameter()]
    $Target = "localhost",
    [Int[]]$Ports = (4000..4004)
)

$Ports | ForEach-Object {
    Start-Job -Name Scanner -ArgumentList $Target, $_ {
       $result = Test-NetConnection -ComputerName $args[0] -Port $args[1] 3>$null
       $result 
    }
} 1>$null


"`n`nScanreport for ${Target}:"
Receive-Job -Wait Scanner* | Sort-Object RemotePort | Format-Table
