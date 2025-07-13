# Liste der Benutzer - passe diese nach Bedarf an
$benutzerListe = @(
    @{Name="Benutzer1"; Passwort="Passwort1!"},
    @{Name="Benutzer2"; Passwort="Passwort2!"},
    @{Name="Benutzer3"; Passwort="Passwort3!"},
    @{Name="Benutzer4"; Passwort="Passwort4!"},
    @{Name="Benutzer5"; Passwort="Passwort5!"}
)

foreach ($benutzer in $benutzerListe) {
    $benutzerName = $benutzer.Name
    $passwort = $benutzer.Passwort

    # Prüfen, ob der Benutzer bereits existiert
    if (Get-LocalUser -Name $benutzerName -ErrorAction SilentlyContinue) {
        Write-Output "Benutzer '$benutzerName' existiert bereits."
    } else {
        try {
            # Passwort sichern
            $securePasswort = ConvertTo-SecureString $passwort -AsPlainText -Force

            # Neuen lokalen Benutzer erstellen
            New-LocalUser -Name $benutzerName -Password $securePasswort -FullName "$benutzerName" -Description "Automatisch angelegter Benutzer" -PasswordNeverExpires
            Write-Output "Benutzer '$benutzerName' wurde erfolgreich erstellt."
        } catch {
            Write-Error "Fehler beim Erstellen des Benutzers '$benutzerName': $_"
        }
    }
}