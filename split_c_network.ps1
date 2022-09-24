param(
    $NetworkAddress = "200.200.200",
    $DigtisToSpend = "11000000"
)

$ips = @{}

$digits_as_int =[System.Convert]::ToInt32( $DigtisToSpend, 2 )

$digits_as_int

for ($i = 0; $i -le 255; $i++) {
    $ips[$digits_as_int -band $i ] += @("$NetworkAddress.$i")
}

$ips