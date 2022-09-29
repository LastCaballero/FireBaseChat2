param(
   $year = 1980,
   $month = 10,
   $day_of_month = 3
)
$birth = Get-Date -Year $year -Month $month -Day $day_of_month
$actual_date = Get-Date
function Get-Physical ( $days ) {
    [Math]::Sin((2*[math]::PI)*$days/23)
}
function Get-Emotianal ( $days ) {
    [Math]::Sin((2*[math]::PI)*$days/28)
}
function Get-Intelligence ( $days ) {
    [Math]::Sin((2*[math]::PI)*$days/33)
}

$data = 0 .. 60 | ForEach-Object {
    
    $ac = $actual_date.AddDays($_)
    $day_diff = ($ac - $birth).Days
    [PSCustomObject]@{
        "Date" = $ac.ToShortDateString()
        "Day diff" = $day_diff
        Physical = Get-Physical($day_diff)
        Emmotional = Get-Emotianal($day_diff)
        Intelligence = Get-Intelligence($day_diff)
    }
    
}

$data | Format-Table Date, "Day diff", @{l="Pyhsical";e={($_.Physical).toString("p")};a="right"},
@{l="Emmotional";e={($_.Emmotional).toString("p")};a="right"},
@{l="Intelligence";e={($_.Intelligence).toString("p")};a="right"}

"`nGeordnet nach Intelligenz"

$data | Sort-Object Intelligence | Format-Table Date, "Day diff", @{l="Pyhsical";e={($_.Physical).toString("p")};a="right"},
@{l="Emmotional";e={($_.Emmotional).toString("p")};a="right"},
@{l="Intelligence";e={($_.Intelligence).toString("p")};a="right"}

"`nGeordnet nach phyischer Konstitution"

$data | Sort-Object Physical | Format-Table Date, "Day diff", @{l="Pyhsical";e={($_.Physical).toString("p")};a="right"},
@{l="Emmotional";e={($_.Emmotional).toString("p")};a="right"},
@{l="Intelligence";e={($_.Intelligence).toString("p")};a="right"}

"`nGeordnet nach emmotionaler Konstitution"

$data | Sort-Object Emmotional | Format-Table Date, "Day diff", @{l="Pyhsical";e={($_.Physical).toString("p")};a="right"},
@{l="Emmotional";e={($_.Emmotional).toString("p")};a="right"},
@{l="Intelligence";e={($_.Intelligence).toString("p")};a="right"}