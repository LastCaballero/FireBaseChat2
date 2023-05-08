Param(
    $Bankbewegungen = "Volksbank_online_banking.csv"
)


$Csv = Import-Csv -Delimiter ";" $Bankbewegungen
$Csv | ForEach-Object { $_.Betrag = [decimal]::Parse( $_.Betrag ) }

class BankBewegung{
    $Datum
    $Betrag
    $Beteiligter
    $Verwendungszweck
    BankBewegung($datum, $betrag, $beteiligter, $verwendungszweck){
        $this.Datum = [datetime]::Parse($datum)
        $this.Betrag = $betrag
        $this.Beteiligter = $beteiligter
        $this.Verwendungszweck = $verwendungszweck
    }
}
$Bewegungen_Array = $Csv | ForEach-Object {
    [BankBewegung]::new($_.Buchungstag, $_.Betrag, $_.'Name Zahlungsbeteiligter', $_.Verwendungszweck)
}


$Beteiligte = $Bewegungen_Array | Group-Object -AsHashTable Beteiligter

class BilanzPosten{
    $Bezeichnung
    $Betrag
    BilanzPosten($bez, $betrag){
        $this.Bezeichnung = $bez
        $this.Betrag = $betrag
    }
}

$Bilanz = @()

$Beteiligte.Keys | ForEach-Object {
    $Summe = 0
    "`n$_"
    "====================================================="
    $Beteiligte[$_] | Sort-Object Datum | ForEach-Object {
        $Summe += $_.Betrag
        $_
    }
    "====================================================="
    "Summe: $Summe"
    $Bilanz += [BilanzPosten]::new($_, $Summe)
}

$Win, $Lost = $Bilanz.Where({ $_.Betrag -ge 0 }, "Split")
$WinSum = ($Win.Betrag | Measure-Object -Sum).Sum
$LostSum = ($Lost.Betrag | Measure-Object -Sum).Sum

$Bilanz | Sort-Object Betrag | Format-Table

"`nWin: "
"==============================================="
$Win | Sort-Object Betrag | Format-Table
"==============================================="
"Summe Einnahmen: $WinSum"
"===============================================`n"


"Lost:"
"==============================================="
$Lost | Sort-Object Betrag | Format-Table
"==============================================="
"Summe Ausgaben: $LostSum"
"===============================================`n"

# Thats´s correct, because the $Lostsum will be negative
$Result = $winSum + $LostSum


"==============================================="
"Gewinn/Verlust: $Result"
"==============================================="
