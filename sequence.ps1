
param (
    [int]$start,
    [int]$end,
    [int]$step = 1 
)

if ( $start -eq $end) {
    throw "start and end must be different!"
} 


$seq = $start..$end
for ( $i = 0; $i -lt $seq.Length ; $i += $step  ) {
    $seq[$i]
}
