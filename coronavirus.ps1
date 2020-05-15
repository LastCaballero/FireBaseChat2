$listeDeutschland = New-Object System.Collections.Generic.List[pscustomobject]
$listeSchweden = New-Object System.Collections.Generic.List[pscustomobject]


$urlde = "https://api.thevirustracker.com/free-api?countryTimeline=de"
$urlse = "https://api.thevirustracker.com/free-api?countryTimeline=se"

$datumde = (Invoke-WebRequest $urlde | ConvertFrom-Json).timelineitems | gm -MemberType NoteProperty | Select-Object -SkipLast 1 -ExpandProperty name
$datumse = (Invoke-WebRequest $urlse | ConvertFrom-Json).timelineitems | gm -MemberType NoteProperty | Select-Object -SkipLast 1 -ExpandProperty name
$itemsde = (Invoke-WebRequest $urlde | ConvertFrom-Json).timelineitems
$itemsse = (Invoke-WebRequest $urlse | ConvertFrom-Json).timelineitems



foreach($x in $datumde){
    $ak = $itemsde.$x
    Add-Member -InputObject $ak -MemberType NoteProperty -Name Datum -Value $x
    $listeDeutschland.Add($ak)
}
foreach($x in $datumse){
    $ak = $itemsse.$x
    Add-Member -InputObject $ak -MemberType NoteProperty -Name Datum -Value $x
    $listeSchweden.Add($ak)
}


"Statistik Deutschland",
($listeDeutschland | ft Datum, new_daily_cases, new_daily_deaths, total_cases, total_recoveries, total_deaths),
"Statistik Schweden",
($listeSchweden | ft Datum, new_daily_cases, new_daily_deaths, total_cases, total_recoveries, total_deaths)


