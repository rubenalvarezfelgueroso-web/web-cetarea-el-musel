# Descarga las fotos originales de la web anterior desde Wayback Machine
# y sustituye los recortes temporales de assets\img.
# Uso: clic derecho sobre este archivo > "Ejecutar con PowerShell"
# (o en una consola: powershell -ExecutionPolicy Bypass -File .\descargar-imagenes-originales.ps1)

$base = "https://web.archive.org/web/20240719061147im_/https://elmusel.es"
$destino = Join-Path $PSScriptRoot "assets\img"

$imagenes = @{
  "slide-1-centollo-bogavante.jpg" = "/system/sliderimages/fotosliders/000/000/013/big/01-1600x680.jpg"
  "slide-2-camion-carretera.jpg"   = "/system/sliderimages/fotosliders/000/000/010/big/Camion-06-v2-1600.jpg"
  "slide-3-barco-rojo.jpg"         = "/system/sliderimages/fotosliders/000/000/012/big/Barco-03-1600x680.jpg"
  "slide-4-cigalas.jpg"            = "/system/sliderimages/fotosliders/000/000/014/big/02-1600x680.jpg"
  "slide-5-flota-camiones.jpg"     = "/system/sliderimages/fotosliders/000/000/009/big/Camion-04-v2-1600.jpg"
  "slide-6-barco-azul.jpg"         = "/system/sliderimages/fotosliders/000/000/011/big/Barco-01-1600x680.jpg"
  "slide-7-mejillones.jpg"         = "/system/sliderimages/fotosliders/000/000/004/big/06-1600x680.jpg"
  "serv-bogavante.jpg"             = "/system/services/fotoservices/000/000/001/original/cabeza-bugre-web.jpg"
  "serv-arroz.jpg"                 = "/system/services/fotoservices/000/000/002/original/04-800x800.jpg"
  "serv-barco.jpg"                 = "/system/services/fotoservices/000/000/003/original/05-800x800.jpg"
  "serv-nave.jpg"                  = "/system/services/fotoservices/000/000/004/original/Instalaciones-Cetarea-800x800_modificado.jpg"
  "not-beneficios.jpg"             = "/system/news_items/fotonews_items/000/000/001/medium/shutterstock_53860441.jpg"
  "not-bogavante-plancha.jpg"      = "/system/news_items/fotonews_items/000/000/002/medium/shutterstock_172685786.jpg"
  "not-bugre.jpg"                  = "/system/news_items/fotonews_items/000/000/003/medium/Bugre-Optimizado.jpg"
  "not-centollo.jpg"               = "/system/news_items/fotonews_items/000/000/004/medium/Centollo-WEB.jpg"
}

$copia = Join-Path $destino "recortes-temporales"
New-Item -ItemType Directory -Force -Path $copia | Out-Null

foreach ($nombre in $imagenes.Keys) {
  $ruta = Join-Path $destino $nombre
  $tmp = "$ruta.descarga"
  try {
    Invoke-WebRequest -Uri ($base + $imagenes[$nombre]) -OutFile $tmp -UseBasicParsing
    if ((Get-Item $tmp).Length -gt 5000) {
      if (Test-Path $ruta) { Copy-Item $ruta (Join-Path $copia $nombre) -Force }
      Move-Item $tmp $ruta -Force
      Write-Host "OK      $nombre"
    } else {
      Remove-Item $tmp
      Write-Host "VACIA   $nombre (se mantiene el recorte)"
    }
  } catch {
    if (Test-Path $tmp) { Remove-Item $tmp }
    Write-Host "ERROR   $nombre : $($_.Exception.Message)"
  }
  Start-Sleep -Milliseconds 800
}
Write-Host ""
Write-Host "Listo. Los recortes anteriores quedan en assets\img\recortes-temporales"
