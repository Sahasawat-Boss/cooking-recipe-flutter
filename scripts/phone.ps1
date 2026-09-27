# Serve the app on the local Wi-Fi and show a QR code to open it on a phone
# (iPhone / Android) — similar to scanning with Expo Go.
# Usage:  .\phone          (or)  .\phone 9000   to use another port
param([int]$Port = 8080)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

# Pick the LAN IPv4 of the active Wi-Fi / Ethernet adapter.
$ip = Get-NetIPConfiguration |
  Where-Object { $_.IPv4DefaultGateway -and $_.NetAdapter.Status -eq 'Up' } |
  Select-Object -First 1 -ExpandProperty IPv4Address |
  Select-Object -ExpandProperty IPAddress

if (-not $ip) {
  Write-Host 'Could not find a Wi-Fi/LAN IP address. Is the PC connected to a network?' -ForegroundColor Red
  exit 1
}

$url = "http://${ip}:$Port"

Write-Host ''
Write-Host '  Easy Cooking - open on your phone' -ForegroundColor Yellow
Write-Host '  1. Connect the phone to the SAME Wi-Fi as this PC'
Write-Host '  2. Scan this QR with the iPhone Camera app (opens in Safari)'
Write-Host ''
npx --yes qrcode --small $url
Write-Host ''
Write-Host "  URL: $url" -ForegroundColor Cyan
Write-Host '  Wait for "is being served at" below before scanning.'
Write-Host '  Press r = hot reload, R = hot restart (then pull-to-refresh in Safari), q = quit'
Write-Host ''

flutter run -d web-server --web-hostname 0.0.0.0 --web-port $Port
