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
    $context.Request.RawUrl
    if ( $context.Request.HttpMethod -eq "POST" ) {
        $reader = [System.IO.StreamReader]::new( $context.Request.InputStream )
        $reader.ReadToEnd() > debug.txt
        $writer.Close()
        Break
    }
    switch( $context.Request.RawUrl ) {
        {$_ -eq "/"} {
            $writer.WriteLine( ( $Top -creplace "TITLE", "Startseite" ) )
            $links = Get-ChildItem $files | Select-Object -ExpandProperty Name
            $links | ForEach-Object { $writer.WriteLine( "<p><a href=`"$_`">$_</a></p>"  )  }
            $writer.WriteLine( $Bottom )
            Break
        }
        {$_ -ne "/"} {
            $filename = $_ -replace "/",""
            if (Test-Path ".\$files\$filename" ) {
                $content = Get-Content -Raw ".\$files\$filename"
                $writer.WriteLine( $content )
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








