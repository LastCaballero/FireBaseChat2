function Get-MyIp(){
    [System.Net.Dns]::GetHostAddresses( [System.Net.Dns]::GetHostName() )[1]
}