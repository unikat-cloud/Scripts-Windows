# Prüfen, ob das Modul PSWindowsUpdate installiert ist
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Output "Das Modul 'PSWindowsUpdate' ist nicht installiert."
    Write-Output "Um das Modul zu installieren, führe folgenden Befehl aus:"
    Write-Output "Install-Module -Name PSWindowsUpdate -Force"
    exit
}

# Modul importieren
Import-Module PSWindowsUpdate

# Suchen nach verfügbaren Updates
Write-Output "Suche nach verfügbaren Windows-Updates..."
$Updates = Get-WindowsUpdate -AcceptAll -IgnoreReboot

if ($Updates) {
    Write-Output "Folgende Updates sind verfügbar:`n$($Updates | Format-Table -AutoSize | Out-String)"
    # Optional: Updates installieren
    Write-Output "Beginne die Installation..."
    Install-WindowsUpdate -AcceptAll -IgnoreReboot -AutoReboot
} else {
    Write-Output "Keine Updates verfügbar."
}