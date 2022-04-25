while ( $true ) {
  [pscustomobject]@{
    firefox = ((Get-Process firefox).CPU | Measure-Object -Average ).Average
    edge = ((Get-Process msedge).CPU | Measure-Object -Average ).Average
  }
  Start-Sleep -Seconds 2
}
