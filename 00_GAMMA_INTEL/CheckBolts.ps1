# V51-CHECK-BOLTS: Mantenimiento Preventivo
Write-Host ">>> Verificando integridad de la red fractal..." -ForegroundColor Cyan
# Buscar si aparecieron .git parásitos
$Parasitos = Get-ChildItem -Path . -Recurse -Hidden -Filter ".git" | Where-Object { $_.FullName -ne (Join-Path "C:\via51-fractal" ".git") }
if ($Parasitos) {
    Write-Host "[!] Alerta: Se detectaron parásitos. Eliminando..." -ForegroundColor Yellow
    $Parasitos | Remove-Item -Recurse -Force
} else {
    Write-Host "[OK] No hay inducción parasitaria." -ForegroundColor Green
}
git status
