$Server = 'outlook.office365.com'
$Port = 993
$User = 'your.mail@live.de'
$Pass = Read-Host -Prompt "Password please" -MaskInput

$Client = [System.Net.Sockets.TcpClient]::new( $Server, $Port )
if ( $Client.Connected ) {
    $Stream = $Client.GetStream()
    $SSL = [System.Net.Security.SslStream]::new( $Stream, $true )
}

$SSL.AuthenticateAsClient( $Server )

function Read-Message() {
    while (
        $Reader.Peek() -ne -1
    ) {
        $Reader.readLine()
    }
}

function Take-Login() {
    $Reader.ReadLine()
    $Writer.WriteLine(". login $User $pass")
    $Writer.Flush()
    $Reader.ReadLine()
}


if ($SSL.IsEncrypted) {
    $Writer = [System.IO.StreamWriter]::new($SSL)
    $Reader = [System.IO.StreamReader]::new($SSL)
    Take-Login
}

