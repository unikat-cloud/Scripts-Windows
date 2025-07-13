# Platzhalter für die Drucker-URL / -Pfad
$druckerPfad = "<Drucker_Sharename oder UNC-Pfad, z.B. \\Server\DruckerName>"

# Optional: Name, den der Drucker im System haben soll
$druckerName = "<Benutzerdefinierter Name oder leer lassen für Standardname>"

# Funktion zum Verbinden eines Netzwerkdruckers
function Verbinde-Netzwerkdrucker {
    param (
        [string]$Pfad,
        [string]$Name
    )

    # Überprüfen, ob der Drucker bereits verbunden ist
    $vorhanden = Get-Printer | Where-Object { $_.Name -eq $Name }
    if ($vorhanden) {
        Write-Output "Der Drucker '$Name' ist bereits verbunden."
    } else {
        try {
            # Drucker verbinden
            Add-Printer -ConnectionName $Pfad
            Write-Output "Drucker verbunden: $Pfad"

            # Optional: Drucker umbenennen, falls ein benutzerdefinierter Name gesetzt ist
            if ($Name -and $Name.Trim() -ne "") {
                # Findet den gerade verbundenen Drucker
                $verbundenerDrucker = Get-Printer | Where-Object { $_.PortName -like "*$Pfad*" }
                if ($verbundenerDrucker) {
                    Rename-Printer -Name $verbundenerDrucker.Name -NewName $Name
                    Write-Output "Drucker umbenannt in: $Name"
                }
            }
        } catch {
            Write-Error "Fehler beim Verbinden des Druckers: $_"
        }
    }
}

# Platzhalter setzen
# Beispiel:
# $druckerPfad = "\\Server\MeinDrucker"
# $druckerName = "Mein Netzwerkdrucker"

# Funktion aufrufen
Verbinde-Netzwerkdrucker -Pfad $druckerPfad -Name $druckerName