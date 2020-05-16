$alle = @{}

$listeLänder = @("de","se","be","at","bg","fr","es","it","pl","lu","hr","el")

$listeLänder.ForEach(
    {
        $liste = New-Object System.Collections.Generic.List[pscustomobject]
        $url = "https://api.thevirustracker.com/free-api?countryTimeline=$_"
        $webrequest = (Invoke-WebRequest $url | ConvertFrom-Json)
        $datum = $webrequest.timelineitems | gm -MemberType NoteProperty | Select-Object -SkipLast 1 -ExpandProperty name
        $items = $webrequest.timelineitems
        $name = $webrequest.countrytimelinedata.info.title
        foreach($x in $datum){
            $ak = $items.$x
            Add-Member -Force -InputObject $ak -MemberType NoteProperty -Name Datum -Value $x
            $liste.Add($ak)
        }
        $name,
        ($liste | ft Datum, new_daily_cases, new_daily_deaths, total_cases, total_recoveries, total_deaths)
        $alle.Add($name,$liste)
    }
)

$alle.Keys.ForEach(
    {
        $_, ($alle[$_] | ft Datum, new_daily_cases, new_daily_deaths, total_cases, total_recoveries, total_deaths)
    }
) | Out-Printer "Microsoft Print to PDF"
