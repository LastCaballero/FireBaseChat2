$suche = Read-Host -Prompt "Bitte einen Suchausdruck eingeben: "
$userreg = Get-ChildItem -Recurse hkcu: -PipelineVariable counter
$counter = 0

$treffer = [ordered]@{}

$userreg | % { $shl = $_ ;
    if($_.ValueCount -eq 0 -and $_.Name -match $suche ){
        $treffer.Add(($counter++).ToString(), $_)
    }
    else{
        $_.GetValueNames().ForEach({
            $wert = $shl.GetValue($_).ToString()
            if( $wert -match $suche) {
                $treffer.Add(($counter++).ToString(), $shl.ToString() + "\" + $_ + "  :  " + $wert)
            }
        })
    }

   
} 

$treffer | Out-GridView -Wait
