
if (!(Test-Path .\daten.csv) -or ((get-date) - (Get-Item .\daten.csv).LastWriteTime).Days -gt 1 ) {
     Invoke-WebRequest https://covid.ourworldindata.org/data/owid-covid-data.csv -OutFile daten.csv     
}
$daten = Import-Csv .\daten.csv 
$groupiert = $daten.Where( { $_.location -ne "World" }) | Group-Object -Property location -AsHashTable

$groupiert.Keys.ForEach( {
          [pscustomobject]@{"Land"         = $_ 
               "Impfungen / 100 Einwohner" = [decimal](($groupiert[$_].total_vaccinations_per_hundred).where( { $_ -ne "" }) | Select-Object -Last 1) 
          } }
) | Sort-Object -Descending -Property "Impfungen / 100 Einwohner" |
ForEach-Object -Begin { $index = 1 } -Process {
     $_ | Add-Member -MemberType NoteProperty -Name Tabellenplatz -Value $index
     $index++
     $_
} | ForEach-Object -Begin { "`nImpfmeisterschaft vom $(Get-Date)" } -Process { $_ } |
Format-Table Tabellenplatz, Land, @{e = { "{0,8:N}" -f $_.'Impfungen / 100 Einwohner' }; l = "Impfungen / 100 Einwohner"; a = "right" }
