param(
    $port = 4000
)
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:${port}/")
$listener.Start()
Write-Host "Listening at ${port}"
Write-Host (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -eq "WLAN"} | Select-Object IPAddress)
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    if ($request.HttpMethod -eq "GET") {
        $responseString = @"
<!DOCTYPE html>
<html>
<head>
    <title>Nachricht an den Keller</title>
    <meta charset="UTF-8">
</head>
<body>
    <form method="post">
        <label for="text-input">Nachricht für den Keller:</label>
        <input type="text" id="text-input" name="message">
        <button type="submit">Submit</button>
    </form>
</body>
</html>
"@
        $responseStream = [System.IO.StreamWriter]::new($context.Response.OutputStream)
        $responseStream.Write($responseString)
        $responseStream.Dispose()
    }
    elseif ($request.HttpMethod -eq "POST") {
        $reader = New-Object System.IO.StreamReader($request.InputStream)
        $body = $reader.ReadToEnd()
        Write-Host (Get-Date).ToString() + ($body -replace "\+", " " -replace "message","" -replace "=", "").ToString()
        $reader.Close()
        $writer = New-Object System.IO.StreamWriter($context.Response.OutputStream)
        $writer.WriteLine("Vielen Dank! Die Nachricht ist angekommen")
        $writer.Dispose()
    }
}
$listener.Stop()

trap{
    $listener.Stop()
    $listener.Dispose()
    break
}
