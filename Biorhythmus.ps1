$pi = [Math]::PI
$geburt = Get-Date -Year 1970 -Month 1 -Day 1
$jetzt = Get-Date
$tage = ($jetzt - $geburt).Days

$liste = [System.Collections.ArrayList]@()

0..60 | % {
    $jetzt_inner = $jetzt.AddDays($_)
    $physical = [Math]::Sin((2*$pi)*($tage+$_)/23)
    $emotional = [Math]::Sin((2*$pi)*($tage+$_)/28)
    $intellectual = [Math]::Sin((2*$pi)*($tage+$_)/33) 
    $liste.Add(
        [pscustomobject]@{
            Datum = $jetzt_inner;
            Physical = $physical;
            Emotional = $emotional;
            Intellectual = $intellectual
        }
    ) *>$null
}

$liste | ft @{l="Datum";e={$_.Datum.toString().subString(0,10)}},
            @{l="Physical";e={"{0,10:p}" -f $_.Physical}},
            @{l="Emotional";e={"{0,10:p}" -f $_.Emotional}},
            @{l="Intellectual";e={"{0,10:p}" -f $_.Intellectual}}
