$year = 1..12 | % {
   for ( $i = 1 ; $true; $i++ ) {
     try { Get-Date -Date "2022.$_.$i" } catch { break }
   }
}

 $year | Format-Wide -Property day -GroupBy Month -Column 7
