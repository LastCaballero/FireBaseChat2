
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

<#
    it is only capable to accept 1 request at time, reading the request, writing a useless message, closing the streams between and waiting once again for a request.
    Therefor nginx and Apache don´t have to expect concurrency :-)
#>
