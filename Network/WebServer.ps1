
$WebServer = [System.Net.HttpListener]::new()
$WebServer.Prefixes.Add("http://localhost:4003/")
$WebServer.Start()

while ($true) {
    $GetContext = $WebServer.GetContext()
    
    $Reader = [System.IO.StreamReader]::new($GetContext.Request.InputStream)
    $Writer = [System.IO.StreamWriter]::new($GetContext.Response.OutputStream)

    $Reader.ReadToEnd()
    $Reader.Close()

    $Writer.WriteLine("Alles angekommen")
    $Writer.Close()    
}
trap {
    $WebServer.Dispose()
}


