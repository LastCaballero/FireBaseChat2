param(
   [datetime] $birth = (Get-Date -Day 25 -Month 10 -Year 1971)
)

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

$data | Sort-Object Intelligence | Format-Table Date, "Day diff", @{l="Pyhsical";e={($_.Physical).toString("p")};a="right"},
@{l="Emmotional";e={($_.Emmotional).toString("p")};a="right"},
@{l="Intelligence";e={($_.Intelligence).toString("p")};a="right"}

$data | Sort-Object Physical | Format-Table Date, "Day diff", @{l="Pyhsical";e={($_.Physical).toString("p")};a="right"},
@{l="Emmotional";e={($_.Emmotional).toString("p")};a="right"},
@{l="Intelligence";e={($_.Intelligence).toString("p")};a="right"}

$data | Sort-Object Emmotional | Format-Table Date, "Day diff", @{l="Pyhsical";e={($_.Physical).toString("p")};a="right"},
@{l="Emmotional";e={($_.Emmotional).toString("p")};a="right"},
@{l="Intelligence";e={($_.Intelligence).toString("p")};a="right"}