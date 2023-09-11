function Get-MyIp(){
    [System.Net.Dns]::GetHostAddresses( [System.Net.Dns]::GetHostName() )[1]
}
function Get-HostPart(){
    param( $Ip )
    ($Ip -split "\.")[ 0 .. 2 ] -join "."
}

function Get-NetworkNames(){
    $MyIp = (Get-MyIp).ToString()
    $HostPart = Get-HostPart -Ip $MyIp
    $List = 1 .. 254 | ForEach-Object { "${HostPart}.$_" }
    $List | ForEach-Object {
        Start-Job -ArgumentList $_ {
            $ip = $args[0]
            try {
                [System.Net.Dns]::GetHostByAddress( $ip )
            } catch {}
        }      
    }
}

function Ping-Around(){
    $MyIp = (Get-MyIp).ToString()
    $HostPart = Get-HostPart -Ip $MyIp
    $List = 1 .. 254 | ForEach-Object { "${HostPart}.$_" }
    $Jobs = $List | ForEach-Object {
        Start-job -ArgumentList $_ {
            $Target = $args[0]
            try {
                [System.Net.NetworkInformation.Ping]::new().Send( $Target, 1 )      
            } catch {}
            
        }
        Write-Progress -Activity "${HostPart}.$_" -PercentComplete $_ / 255
        
    } 
    $Jobs | Receive-Job -Wait | Select-Object Address, Status |
        Where-Object { $_.Status -eq "Success" } |  Format-Table -AutoSize
}

Get-NetworkNames

