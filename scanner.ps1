
[CmdletBinding()]
param (
    [Parameter()]
    $Target = "127.0.0.1",
    [Int[]]$PortList 
)


class Sniper{
    [System.Threading.Tasks.Task]$TaskTcp
    [System.Net.Sockets.TcpClient]$Client
    [string]$Target
    [int]$Port
    Sniper([string]$Target, [int]$Port){
        $this.Client = [System.Net.Sockets.TcpClient]::new()
        $this.Target = $Target
        $this.Port = $Port
    }

    [void]Connect(){
        $this.TaskTcp = $this.Client.ConnectAsync($this.Target, $this.Port)
    }
    [bool]GetResult(){
        return $this.TaskTcp.IsCompleted -and -not $this.TaskTcp.IsFaulted 
    }
}


$sniper = [Sniper]::new("localhost", 4000)
$sniper.Connect()
[System.Threading.Thread]::Sleep(1000)
$sniper.GetResult()
