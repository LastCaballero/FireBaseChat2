function Get-Lines {
    Begin {
        $line = 1
    }
    Process {
        "{0,2} {1,2}" -f $line, $_
        $line++
    }
    
}

function Get-Sum {
    Begin {
        $sum = 0
    }
    Process {
        $sum += $_
    }
    End {
        $sum
    }
    
}

function Get-Avg {
    Begin {
        $sum = 0
        $count = 0
    }
    Process {
        $sum += $_
        $count++
    }
    End {
        $sum / $count
    }
    
}

