Add-Content -LiteralPath C:\New-WVDSessionHost.log "Edge Optimization"
Push-Location 
Set-Location HKLM:\SOFTWARE\

New-Item `
    -Path HKLM:\Software\Policies\Microsoft `
    -Name Edge `
    -Value "" `
    -Force

#stop on the Edge update 89 waiting for new update with new release of the feature
#New-ItemProperty `
    #-Path HKLM:\Software\Policies\Microsoft\MicrosoftEdge `
    #-Name "StartupBoostEnabled" `
    #-Type "Dword" `
    #-Value "1"

New-ItemProperty `
    -Path HKLM:\Software\Policies\Microsoft\Edge\ `
    -Name "SleepingTabsEnabled" `
    -Type "Dword" `
    -Value "1"
New-ItemProperty `
    -Path HKLM:\Software\Policies\Microsoft\Edge\ `
    -Name "SleepingTabsTimeout" `
    -Type "Dword" `
    -Value "3600"
#Change the value if you want an other inactivity value to put edge an inactive
#value 300 = 5 minutes of inactivity
#value 900 = 15 minutes of inactivity
#value 1800 = 30 minutes of inactivity
#value 3600 = 1 hour of inactivity
#value 7200 = 2 hours of inactivity (default)
#value 10800 = 3 hours of inactivity
#value 21600 = 6 hours of inactivity
#value 43200 = 12 hours of inactivity