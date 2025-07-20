# Schritt 1: Alle Netzwerkadapter anzeigen
$adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
Write-Host "Verfügbare Netzwerkadapter:"
for ($i = 0; $i -lt $adapters.Count; $i++) {
    Write-Host "$i) $($adapters[$i].Name)"
}

# Schritt 2: Benutzer wählt Adapter
$selection = Read-Host "Bitte geben Sie die Nummer des gewünschten Netzwerkadapters ein"
if ($selection -notmatch '^\d+$' -or $selection -ge $adapters.Count) {
    Write-Error "Ungültige Auswahl."
    exit
}
$adapterName = $adapters[$selection].Name

# Schritt 3: Netzwerkdetails abfragen
$ipAddress = Read-Host "Geben Sie die IP-Adresse ein (z.B. 192.168.1.100)"
$subnetMask = Read-Host "Geben Sie die Subnetzmaske ein (z.B. 255.255.255.0)"
$gateway = Read-Host "Geben Sie das Gateway ein (z.B. 192.168.1.1)"

# DNS-Server 1 abfragen
$dns1 = Read-Host "Geben Sie den ersten DNS-Server ein (z.B. 8.8.8.8)"
# DNS-Server 2 abfragen (optional)
$dns2 = Read-Host "Geben Sie den zweiten DNS-Server ein (oder lassen Sie leer für nur einen DNS)"

// Schritt 4: Netzwerk konfigurieren
# IP-Adresse setzen
# Berechnung des PrefixLength aus Subnetzmaske
function Convert-SubnetMaskToPrefixLength($mask) {
    $binary = ($mask -split '\.') | ForEach-Object { [Convert]::ToString([int]$_, 2).PadLeft(8,'0') }
    return ($binary -join '').Count('1')
}
$prefixLength = Convert-SubnetMaskToPrefixLength $subnetMask

# IP konfigurieren
Write-Host "Setze statische IP-Adresse..."
Set-NetIPAddress -InterfaceAlias $adapterName -IPAddress $ipAddress -PrefixLength $prefixLength -DefaultGateway $gateway -ErrorAction SilentlyContinue

if ($LASTEXITCODE -ne 0) {
    # Bei Fehler, eventuell PrefixLength manuell setzen
    Set-NetIPAddress -InterfaceAlias $adapterName -IPAddress $ipAddress -PrefixLength $prefixLength -DefaultGateway $gateway
}

# DNS-Server konfigurieren
$dnsServers = @($dns1)
if ($dns2 -and $dns2.Trim() -ne "") {
    $dnsServers += $dns2
}
Write-Host "Setze DNS-Server(s) auf: $($dnsServers -join ', ')"
Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses $dnsServers

Write-Host "Netzwerkeinstellungen wurden aktualisiert."