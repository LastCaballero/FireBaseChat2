function Num-Lines {
    Begin {
        $lines = [System.Collections.ArrayList]::new()
    }
    Process {
        $lines.Add( $_ ) 1>$null
    }
    End{
        $args | ForEach-Object {
            if( Test-Path $_ ){
                Get-Content $_ | ForEach-Object { 
                    $lines.Add( $_ ) 1>$null
                }
            }
        }
        $line = 1
        $formatter = $lines.Count.ToString().Length
        $lines | ForEach-Object {
          "{0,$formatter} {1}" -f $line, $_
          $line++
        }
    }
}
