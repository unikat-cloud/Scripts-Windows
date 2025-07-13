# PowerShell-Skript zum Deaktivieren der UAC-Benutzerbestätigungen

# Der Registrierungspfad für die UAC-Einstellungen
$uacRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# Wertname für die UAC-Nummer (EnableLUA)
$uacValueName = "EnableLUA"

# UAC auf Deaktiviert setzen (0 = Deaktiviert)
Set-ItemProperty -Path $uacRegistryPath -Name $uacValueName -Value 0

Write-Output "UAC wurde deaktiviert. Bitte starten Sie den Computer neu, damit die Änderungen wirksam werden."