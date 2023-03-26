param(
    [int]$Port = 4000
)

function Style(){
    return @"
<style>
    body {
        font-family: sans-serif ;
        margin: 45px ;
    }
</style>
"@
}

function Form($recipient){
    return @"
        <form method="post" action="/send">
        <label for="text-input">your message for ${recipient}</label><br>
        <textarea id="text-input" rows="7" cols="45" name="message"></textarea>
        <button type="submit">Submit</button>
</form>
"@
}

function HTMLTop( $title ) {
    
    return @"
        <!DOCTYPE html>
        <html>
        <head>
        <title> $title </title>
        <meta charset="UTF-8">
        $($(Style))
        </head>
        <body>
"@
}
function HTMLBottom() {
    return @"
    </body>
    </html>
"@
}



$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:${port}/")
$listener.Start()

Write-Host "Listening at ${port}"
Write-Host (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -eq "WLAN"} | Select-Object IPAddress)

while( $listener.IsListening ){
    $context = $listener.GetContext()
    $request = $context.Request
    $respond = $context.Response
    $responder = [System.IO.StreamWriter]::new( $respond.OutputStream )
    if($request.HttpMethod -eq "GET"){
        $top = HTMLTop "Message Formular"
        $form = Form "Me"
        $bottom = HTMLBottom
        $responder.Write( $top+ $form + $bottom )
        $responder.Close()
    } else{
        $reader = [System.IO.StreamReader]::new($request.InputStream)
        $message = [Net.WebUtility]::UrlDecode($reader.ReadToEnd())
        $top = HTMLTop "We received your message"
        $info = "<p>We received your message! Thank you!</p>"
        $bottom = HTMLBottom
        $responder.Write( $top + $info + $bottom )
        $reader.Dispose()
        $responder.Close()
        Write-Host "$(Get-Date) $message"
    }
}



trap{
    $listener.Dispose()
}
