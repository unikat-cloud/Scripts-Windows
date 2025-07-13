# Platzhalter für den Netzlaufwerkbuchstaben (z.B. Z:)
$driveLetter = "Z:"  # Ersetze durch den gewünschten Laufwerksbuchstaben

# Platzhalter für den Netzwerkpfad (z.B. \\Server\Freigabe)
$networkPath = "\\Server\Freigabe"  # Ersetze durch den entsprechenden Netzwerkpfad

# Platzhalter für Benutzername und Passwort (falls benötigt)
$username = "BENUTZERNAME"  # Beispiel: "domäne\benutzer" oder nur "benutzer"
$password = "PASSWORT"      # Beispiel: "meinpasswort"

# Bestätigungsabfrage vor Ausführung
Write-Host "WARNUNG: Das Skript wird ein Netzlaufwerk verbinden." -ForegroundColor Yellow
Write-Host "Folgende Risiken bestehen:"
Write-Host "- Unbefugter Zugriff: Wenn das Skript in falsche Hände gerät, könnten Passwörter offengelegt werden."
Write-Host "- Versehentliche Weitergabe: Das Skript könnte versehentlich an unbefugte Personen gelangen."
Write-Host "- Schwachstellen in Automatisierungen: Automatisierte Prozesse mit Passwörtern können Angriffsziele sein."
$confirmation = Read-Host "Möchten Sie fortfahren? (J/N)"

if ($confirmation.ToUpper() -ne 'J') {
    Write-Host "Skriptabbruch durch Benutzer." -ForegroundColor Red
    exit
}

# Verbindung zum Netzlaufwerk herstellen
try {
    # Falls das Laufwerk bereits verbunden ist, kann man es vorher entfernen
    if (Get-PSDrive -Name $driveLetter.TrimEnd(':') -ErrorAction SilentlyContinue) {
        Remove-PSDrive -Name $driveLetter.TrimEnd(':') -Force
    }

    # Ohne Credential verbinden (falls keine Anmeldedaten erforderlich sind)
    # Wenn Authentifizierung notwendig ist, muss der Teil mit Credentials ergänzt werden
    New-PSDrive -Name ($driveLetter.TrimEnd(':')) -PSProvider FileSystem -Root $nameSpace -Persist
    Write-Host "Netzlaufwerk $driveLetter wurde erfolgreich verbunden." -ForegroundColor Green
} catch {
    Write-Error "Fehler beim Verbinden des Netzlaufwerks: $_"
}
