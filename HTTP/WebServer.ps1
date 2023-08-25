param(
    $files = "files",
    $port = 4000
)

if ( (Test-Path $files) -eq $false ) {
    New-Item -ItemType Directory $files
}


$Top = @"
    <html>
        <head>
            <title>
                TITLE
            </title>
        </head>
    <body>
"@

$Bottom = @"
    </body>
    </html>
"@

$server = [System.Net.HttpListener]::new()
$server.Prefixes.Add("http://localhost:$port/")
$server.Start()


while ( $true ) {
    $context = $server.GetContext()
    $writer = [System.IO.StreamWriter]::new( $context.Response.OutputStream )
    switch( $context.Request.RawUrl ) {
        {$_ -eq "/"} {
            $writer.WriteLine( ( $Top -creplace "TITLE", "Startseite" ) )
            $writer.WriteLine("hallo")
            $writer.WriteLine( $Bottom )
            Break
        }
        {$_ -ne "/"} {
            if( Test-Path $_ ){
                $writer.Write( ( Get-Content $_ ) )
            }
            Break
        }
    } 
    
    $writer.Close()
}


trap {
   $server.Stop()
   $server.Dispose()
}








