
$Count = 1

$start = Get-Date

while ( $true ) {
    Read-Host

        @{
            Frequence = ( ( Get-Date ) - $start ) / $Count
            Now = Get-Date
        } | select Now, Frequence
    
    $Count++
}