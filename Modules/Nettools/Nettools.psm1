function Get-KnownNetworkNames(){
    param(
        $MyTarget = [System.Net.Dns]::GetHostAddresses( [System.Net.Dns]::GetHostName() )[1].ToString(),
        $HostPart = ($MyTarget -split "\.")[ 0 .. 2 ] -join ".",
        $Ips = ( 1 .. 254 | ForEach-Object { "${HostPart}.$_" } )
    )
    
    $Tasks = $Ips | ForEach-Object { try { [System.Net.Dns]::GetHostEntryAsync( $_ ) } catch {} }
    ( $Tasks | Where-Object { $null -ne $_.Result } ).Result
}

function Ping-Around(){
    param(
        $MyTarget = [System.Net.Dns]::GetHostAddresses( [System.Net.Dns]::GetHostName() )[1].ToString(),
        $HostPart = ($MyTarget -split "\.")[ 0 .. 2 ] -join ".",
        $Ips = ( 1 .. 254 | ForEach-Object { "${HostPart}.$_" } )
    )

    $Tasks = $Ips | ForEach-Object { [System.Net.NetworkInformation.Ping]::new().SendPingAsync($_) }
    $Tasks.Result | Where-Object { $_.Status -eq "Success" } | Format-Table
}

function Get-OpenTcpPorts {
    param(
        [string]$Target = "192.168.178.1",
        [int[]]$PortRange = 1 .. 400
    )
    $Clients = $PortRange | ForEach-Object {
        $client = [System.Net.Sockets.TcpClient]::new()
        $client.ConnectAsync( $Target, $_ )
        $client.Client
    }
    Start-Sleep -Seconds 5
    $Clients | Where-Object { $_.Connected } | Format-Table LocalEndPoint, RemoteEndPoint, SocketType, ProtocolType, Available
    $Clients | Where-Object { $_.Connected } |
    ForEach-Object { $_.DisconnectAsync( [System.EventArgs]::new() ) ; $_.Dispose() } 1>$null; 2>$null
}



