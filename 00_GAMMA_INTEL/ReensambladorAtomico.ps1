# SCRIPT DE RE-ENSAMBLAJE V51
# MANTRA: "La fuerza unida es poder."

$FragmentDir = "C:\via51-fractal\01_HOLDING_EXPANSION\L1_PRODUCCION\L2_LE_POMMIER\FRAGMENTS"
$OutputFile  = "C:\via51-fractal\01_HOLDING_EXPANSION\L1_PRODUCCION\L2_LE_POMMIER\LE_PROMMIER_RESTORED.rar"

Write-Host ">>> Iniciando Re-ensamblaje Soberano..." -ForegroundColor Cyan

$Parts = Get-ChildItem -Path $FragmentDir -Filter "*.v51" | Sort-Object Name
if ($Parts.Count -eq 0) { Write-Host "No se encontraron fragmentos." -ForegroundColor Red; exit }

[System.IO.File]::WriteAllBytes($OutputFile, @()) # Crear archivo vacío

foreach ($Part in $Parts) {
    Write-Host "Uniendo $($Part.Name)..." -ForegroundColor White
    $Bytes = [System.IO.File]::ReadAllBytes($Part.FullName)
    
    # Abrir para añadir (Append)
    $Stream = [System.IO.File]::Open($OutputFile, [System.IO.FileMode]::Append)
    $Stream.Write($Bytes, 0, $Bytes.Length)
    $Stream.Close()
}

Write-Host "------------------------------------------------------------" -ForegroundColor Green
Write-Host "ACTIVO RECONSTRUIDO: $OutputFile" -ForegroundColor Green
Write-Host "------------------------------------------------------------"
