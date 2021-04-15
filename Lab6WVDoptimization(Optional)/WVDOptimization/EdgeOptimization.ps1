#optimize Edge

Add-Content -LiteralPath C:\New-WVDSessionHost.log "Edge Optimization"
Push-Location 
Set-Location HKLM:\SOFTWARE\

#stop on the Edge update 89 waiting for new update with new release of the feature
#New-ItemProperty `
    #-Path HKLM:\Software\Policies\Microsoft\Edge `
    #-Name "StartupBoostEnabled" `
    #-Type "Dword" `
    #-Value "1"

New-ItemProperty `
    -Path HKLM:\Software\Policies\Microsoft\Edge `
    -Name "SleepingTabsEnabled" `
    -Type "Dword" `
    -Value "1"
