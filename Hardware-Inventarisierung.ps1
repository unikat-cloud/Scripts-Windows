# Hardware Inventarisierung in PowerShell - einfaches Script

# Zielpfad für die Exportdatei
$exportPath = "C:\Hardware_Inventar.txt"

# Systeminformationen sammeln
$computerInfo = Get-ComputerInfo
$bios = Get-CimInstance -ClassName Win32_BIOS
$cpu = Get-CimInstance -ClassName Win32_Processor
$ramModules = Get-CimInstance -ClassName Win32_PhysicalMemory
$diskDrives = Get-CimInstance -ClassName Win32_DiskDrive
$motherboard = Get-CimInstance -ClassName Win32_BaseBoard
$videoAdapters = Get-CimInstance -ClassName Win32_VideoController

# Ausgabe sammeln
$output = @()

# Allgemeine Systeminformationen
$output += "=== Allgemeine Systeminformationen ==="
$output += "Hostname: $($computerInfo.CsName)"
$output += "Betriebssystem: $($computerInfo.OsName) $($computerInfo.OsVersion)"
$output += "Systemhersteller: $($computerInfo.CsManufacturer)"
$output += "Systemmodell: $($computerInfo.CsModel)"
$output += ""

# BIOS
$output += "=== BIOS Informationen ==="
$output += "Hersteller: $($bios.Manufacturer)"
$output += "Version: $($bios.SMBIOSBIOSVersion)"
$output += "Seriennummer: $($bios.SerialNumber)"
$output += ""

# CPU
$output += "=== CPU Informationen ==="
$output += "Name: $($cpu.Name)"
$output += "Hersteller: $($cpu.Manufacturer)"
$output += "Kerne: $($cpu.NumberOfCores)"
$output += "Threads: $($cpu.NumberOfLogicalProcessors)"
$output += ""

# Arbeitsspeicher
$output += "=== Arbeitsspeicher ==="
foreach ($module in $ramModules) {
    $sizeGB = [Math]::Round($module.Capacity / 1GB, 2)
    $MemoryType = switch ($module.MemoryType) {
        0 { "Unbekannt" }
        1 { "No" }
        2 { "DRAM" }
        3 { "Synchronous DRAM" }
        4 { "Cache DRAM" }
        5 { "EDO" }
        6 { "EDRAM" }
        7 { "VRAM" }
        8 { "SRAM" }
        9 { "RAM" }
        10 { "ROM" }
        11 { "Flash" }
        12 { "EEPROM" }
        13 { "FEPROM" }
        14 { "EPROM" }
        15 { "CDRAM" }
        16 { "3DRAM" }
        17 { "SDRAM" }
        18 { "SGRAM" }
        19 { "RDRAM" }
        20 { "DDR" }
        21 { "DDR2" }
        22 { "DDR2 FB-DIMM" }
        24 { "DDR3" }
        25 { "FBD2" }
        26 { "DDR4" }
        default { "Unbekannt" }
    }
    $output += "Modul: $($module.DeviceLocator), Größe: $sizeGB GB, Typ: $MemoryType"
}
$output += ""

# Festplatten
$output += "=== Festplatten ==="
foreach ($disk in $diskDrives) {
    $sizeGB = [Math]::Round($disk.Size / 1GB, 2)
    $interfaceType = $disk.InterfaceType
    $model = $disk.Model
    $serial = $disk.SerialNumber
    $output += "Modell: $model"
    $output += "Schnittstelle: $interfaceType"
    $output += "Kapazität: $sizeGB GB"
    $output += ""
}

# Mainboard
$output += "=== Mainboard ==="
$output += "Hersteller: $($motherboard.Manufacturer)"
$output += "Produkt: $($motherboard.Product)"
$output += "Seriennummer: $($motherboard.SerialNumber)"
$output += ""

# Grafikkarte
$output += "=== Grafikkarte ==="
foreach ($v in $videoAdapters) {
    $memoryMB = [Math]::Round($v.AdapterRAM / 1MB, 2)
    $output += "Name: $($v.Name)"
    $output += "Video RAM: $memoryMB MB"
}
$output += ""

# In Datei exportieren
$output | Out-File -FilePath $exportPath -Encoding UTF8

Write-Host "Hardware Inventar wurde erstellt: $exportPath"
