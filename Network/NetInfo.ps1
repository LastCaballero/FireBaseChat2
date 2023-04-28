$LocalIP = (Get-NetIPAddress | ? PrefixOrigin -eq "Dhcp").IPAddress
$WebIp = (Invoke-WebRequest "https://api.ipify.org").Content
$LocalGateWay = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop

$info = [System.Management.Automation.PSCustomObject]@{
    "Local-IP:" = $LocalIP
    "Web-IP:" = $WebIp
    "Local GateWay:" = $LocalGateWay
}

$info