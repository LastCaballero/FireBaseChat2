function Set-Vars(){
    $Global:MyIp = [System.Net.Dns]::GetHostAddresses( [System.Net.Dns]::GetHostName() )[1].ToString()
    $Global:HostPart = ($MyIp -split "\.")[ 0 .. 2 ] -join "." 
    $Global:Ips = 1 .. 254 | ForEach-Object { "${HostPart}.$_" }
}


function Get-KnownNetworkNames(){
    Set-Vars
    $Tasks = $Ips | ForEach-Object { try { [System.Net.Dns]::GetHostEntryAsync( $_ ) } catch {} }
    ( $Tasks | Where-Object { $_.Result -ne $null } ).Result
}

function Ping-Around(){
    Set-Vars
    $Tasks = $Ips | ForEach-Object { [System.Net.NetworkInformation.Ping]::new().SendPingAsync($_) }
    $Tasks.Result | Where-Object { $_.Status -eq "Success" } | Format-Table
}


