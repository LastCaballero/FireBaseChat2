$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:4000/")
$listener.Start()

while ($true) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    if ($request.HttpMethod -eq "POST") {
        $streamReader = New-Object System.IO.StreamReader $request.InputStream
        $boundary = $request.ContentType.Split(";")[1].Split("=")[1]
        $fileContent = $streamReader.ReadToEnd().Split("--$boundary`r`n") | Where-Object { $_ -like "*filename*"}
        $fileName = "$env:HOMEPATH\Downloads\"
        $fileName += [regex]::Match($fileContent, 'filename="(.*)"').Groups[1].Value
        [System.IO.File]::WriteAllText($fileName, $fileContent.Split("`r`n`r`n")[1])
        $fileChange = Get-Content -Path $fileName
        $fileChange[0..($fileContent.Count - 1)] | Set-Content -Path $fileName
        $response.StatusCode = 200
        $inform = [System.IO.StreamWriter]::new($response.OutputStream)
        $inform.WriteLine("File received")
        $inform.Dispose()
        $response.Close()
    } else {
        $response.ContentType = "text/html"
        $html = @"
<form method="post" enctype="multipart/form-data">
    <input type="file" name="file">
    <input type="submit" value="Submit">
</form>
"@
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.Close()
    }
}

trap{
    $listener.Dispose()
}