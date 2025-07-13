# Funktion: Startmenü leeren
function Clear-StartMenu {
    Copy-Item -Path "$newDirectoryPath\start_leer.bin" -Destination "$env:LOCALAPPDATA\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin" -Force
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Process explorer
}