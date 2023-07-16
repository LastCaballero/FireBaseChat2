function Num-Lines {
    param(
        [string]$file = $null
    )
    Begin {
        $lines = [System.Collections.ArrayList]::new()
    }
    Process {
        $lines.Add( $_ ) 1>$null
        
    }
    End{
        if( $file -ne $null -and (Test-Path $File) ) {
            Get-Content $file | ForEach-Object {
                $lines.Add( $_ ) 1>$null
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
