param (
    [Parameter()]
    $Target = "localhost",
    [Int[]]$Ports = (4000..4004)+22+33
)

$Ports | ForEach-Object {
    Start-Job -Name Scanner -ArgumentList $Target, $_ {
        try {
            $socket = [System.Net.Sockets.TcpClient]::new()
            $socket.Connect( $args[0], $args[1] )
            "{0,-10}`t{1}" -f $args[1].ToString(), "open"
            $socket.Dispose()
        }catch {
            "{0,-10}`t{1}" -f $args[1].ToString(), "closed"
        } 
    } 1>$null
}


"`n`nScanreport for ${Target}:"
( Receive-Job -Wait Scanner* ) | Sort-Object

