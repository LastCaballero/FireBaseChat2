function Num-Lines {
    Begin {
        $lines = [System.Collections.ArrayList]::new()
    }
    Process {
        $lines.Add( $_ ) 1>$null
    }
    End{
        $line = 1
        $formatter = $lines.Count.ToString().Length
        $lines | ForEach-Object {
          "{0,$formatter} {1}" -f $line, $_
          $line++
        }
    }
}
