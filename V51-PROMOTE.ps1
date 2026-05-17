param([string]$Target)
$ValidTargets = @("alfa", "beta", "gamma", "holding")
if ($Target -notin $ValidTargets) { Write-Host "[!] Error: Use alfa, beta, gamma o holding." -ForegroundColor Red; exit }
Write-Host ">>> PROMOVIENDO CARGA DE ROOT A $Target..." -ForegroundColor Cyan
Copy-Item -Path "C:\via51-fractal\via51-root\index.html" -Destination "C:\via51-fractal\via51-$Target\index.html" -Force
git add .
git commit -m "V51-RELEASE: Promoción de ROOT a $Target."
git push origin main
Write-Host "[OK] $Target actualizado en la nube." -ForegroundColor Green
