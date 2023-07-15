4000 .. 4004 | ForEach-Object {
    Start-Job -Name "Sniper$_" -ArgumentList $_ {
        $port = $args[0]
        $sniper = [System.Net.Sockets.TcpListener]::new( $port ) 2>$null
        $sniper.Start()
        while ( $true ) {
            $other = $sniper.AcceptTcpClient()
            $other.Close()
            $port
        }
        trap {
            $sniper.Server.Dispose()
        }
    }

}

while ( $true ) {
    Start-Sleep -Seconds 3
    Receive-Job Sniper*
}

trap {
    Get-Job Sniper* | Stop-Job
    Get-Job Sniper* | Remove-Job
}
