
param (
	$scan_target = "localhost",
	$rng_start = 4000,
	$rng_end = 4030
)

$rng_start .. $rng_end | ForEach-Object {
	Start-Job -Name "Scanjob" -ArgumentList $scan_target, $_ {
		$client = $null
		try {
			$client = [System.Net.Sockets.TcpClient]::new($args[0], $args[1])
			if ( $client ) {
				$client.Close()
				return [pscustomobject]@{ scannedhost = $args[0]; port = $args[1]; online = $true }	
			}	
		}
		catch {
			return [pscustomobject]@{ scannedhost = $args[0]; port = $args[1]; online = $false }
		}	
		
	}
}

