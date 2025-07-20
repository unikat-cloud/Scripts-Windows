# Script zum Ändern des Computernamens mit interaktiver Eingabe

# Funktion zur Eingabe des neuen Computernamens
$newComputerName = Read-Host -Prompt "Bitte geben Sie den neuen Computernamen ein"

# Optional: Überprüfen, ob der Name gültig ist
if ([string]::IsNullOrWhiteSpace($newComputerName)) {
    Write-Host "Der eingegebene Name ist ungültig. Das Script wird beendet." -ForegroundColor Red
    exit
}

# Anzeige des neuen Namens zur Bestätigung
Write-Host "Der Computername wird zu '$newComputerName' geändert..."

try {
    Rename-Computer -NewName $newComputerName -Restart -Force
    Write-Host "Der Computer wird nun neu gestartet, um die Namensänderung abzuschließen." -ForegroundColor Green
} catch {
    Write-Host "Fehler beim Ändern des Computernamens: $_" -ForegroundColor Red
}
