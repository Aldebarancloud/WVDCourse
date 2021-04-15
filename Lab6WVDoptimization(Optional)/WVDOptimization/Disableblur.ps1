#optimize WVD disable acrylic effect on the sign-in screen

Add-Content -LiteralPath C:\New-WVDSessionHost.log "WVD Optimization"
Push-Location 
Set-Location HKLM:\SOFTWARE\
New-ItemProperty `
    -Path HKLM:\Software\Policies\Microsoft\Windows\System `
    -Name "DisableAcrylicBackgroundOnLogon" `
    -Type "Dword" `
    -Value "1"
