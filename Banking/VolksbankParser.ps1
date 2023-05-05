Param(
    $Bankbewegungen = "Volksbank_online_banking.csv"
)



$Csv = Import-Csv -Delimiter ";" $Bankbewegungen
$Csv | ForEach-Object { $_.Betrag = [decimal]::Parse( $_.Betrag ) }

class BankBewegung{
    $Datum
    $Betrag
    BankBewegung($datum, $betrag){
        $this.Datum = [datetime]::Parse($datum)
        $this.Betrag = $betrag
    }
}

$Zahlungsbeteiligte = $Csv | Group-Object -AsHashTable "Name Zahlungsbeteiligter"

$Zahlungsbeteiligte.Keys | ForEach-Object {
    "`n"
    $_
    $Summe = 0
    $Zahlungsbeteiligte[$_] | ForEach-Object {
        $Summe += $_.Betrag
        [BankBewegung]::new($_.Buchungstag, $_.Betrag)
    } | Sort-Object -Property Datum | Format-Table @{l="Datum";e={$_.Datum.ToShortDateString()}},Betrag
    "---------------------------"
    "Summe: $Summe"
}
