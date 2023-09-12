
function Get-KnownNetworkNames(){
    $MyIp = [System.Net.Dns]::GetHostAddresses( [System.Net.Dns]::GetHostName() )[1].ToString()
    $HostPart = ($MyIp -split "\.")[ 0 .. 2 ] -join "." 
    $Ips = 1 .. 254 | ForEach-Object { "${HostPart}.$_" }
    $Tasks = $Ips | ForEach-Object { try { [System.Net.Dns]::GetHostEntryAsync( $_ ) } catch {} }
    ( $Tasks | Where-Object { $_.Result -ne $null } ).Result
}

function Ping-Around(){
    $MyIp = [System.Net.Dns]::GetHostAddresses( [System.Net.Dns]::GetHostName() )[1].ToString()
    $HostPart = ($MyIp -split "\.")[ 0 .. 2 ] -join "." 
    $Ips = 1 .. 254 | ForEach-Object { "${HostPart}.$_" }
    $Tasks = $Ips | ForEach-Object { [System.Net.NetworkInformation.Ping]::new().SendPingAsync($_) }
    $Tasks.Result | Where-Object { $_.Status -eq "Success" } | Format-Table
}

