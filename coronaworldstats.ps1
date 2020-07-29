$abfrage=(ConvertFrom-Json -InputObject (Invoke-WebRequest "https://covid.ourworldindata.org/data/owid-covid-data.json"));(($abfrage | gm).Name |
Select-Object -Skip 4).forEach({$abfrage.$_ | fl co*,loca*,pop*; $abfrage.$_.data | ft}) | Out-String | Out-File CoronaStats.txt
