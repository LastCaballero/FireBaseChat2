function download {
     if (!(Test-Path .\daten.csv) -or
          ((Get-Date) - (get-item .\daten.csv).CreationTime).hours -gt 30
     ) {
          Invoke-WebRequest https://covid.ourworldindata.org/data/owid-covid-data.csv -OutFile daten.csv     
     }  
}
download
$stringbuilder =  [System.Text.StringBuilder]::new("date,")
$daten = Import-Csv .\daten.csv
$spalten = $daten | Get-Member -Type NoteProperty
$groupiert = $daten | Group-Object -Property location -AsHashTable
$spalten_bereinigt = $spalten.Name |
Where-Object { $_ -ne "date" -and $_ -ne "location" -and $_ -ne "iso_code" -and $_ -ne "continent" }

$ausgewaehltes_land=$groupiert.Keys | Out-GridView -OutputMode Single -Title "Bitte ein Land auswählen"

$ausgewaehlte_spalten = $spalten_bereinigt | Out-GridView -OutputMode Multiple -Title "Bitte die Spalten auswählen" |
ForEach-Object {
     $stringbuilder.Append($_ + ",")
}
$spaltenauswahl = ($stringbuilder.ToString() -replace ",$","") -split ","
$spaltenauswahl.Where({$_ -ne "date"}).foreach{
     $ausdruck = $_
     $groupiert[$ausgewaehltes_land].ForEach{
          $_.$ausdruck = [decimal]$_.$ausdruck
     }
}

$groupiert[$ausgewaehltes_land] | Select-Object $spaltenauswahl | Out-GridView -Title $ausgewaehltes_land -Wait
$groupiert[$ausgewaehltes_land] | Select-Object $spaltenauswahl | Format-Table -AutoSize
