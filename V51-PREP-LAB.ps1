param([string]$SourceNode)
$ValidSources = @("alfa", "beta", "gamma", "holding")
if ($SourceNode -notin $ValidSources) { Write-Host "[!] Error: Use alfa, beta, gamma o holding." -ForegroundColor Red; exit }
Write-Host ">>> TRAYENDO CARGA DE $SourceNode AL LABORATORIO..." -ForegroundColor Cyan
Copy-Item -Path "C:\via51-fractal\via51-$SourceNode\index.html" -Destination "C:\via51-fractal\via51-root\index.html" -Force
Write-Host "[OK] Mesa de trabajo lista en ROOT." -ForegroundColor Green
