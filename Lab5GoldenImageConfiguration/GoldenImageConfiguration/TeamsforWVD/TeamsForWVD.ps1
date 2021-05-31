[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Variables Teams
$TeamsSource = "https://statics.teams.cdn.office.net/production-windows-x64/1.4.00.8872/Teams_windows_x64.msi"
$locationteamsdownload = "C:\"
$locationteams = "C:\Teams_windows_x64.msi"

#Regedit Teams for WVD
reg add "HKLM\SOFTWARE\Microsoft\Teams" /v IsWVDEnvironment /t REG_DWORD /d 1 /f

#Download Teams Source x64
Start-BitsTransfer -Source $TeamsSource -Destination $locationteamsdownload

#Run this following command to install Teams
msiexec /i $locationteams /l*v teams_install.log ALLUSERS=1 ALLUSER=1

#Fallback mode in Teams
#audio only
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Teams\DisableFallback" /t REG_DWORD /d 1 /f
#Disable
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Teams\DisableFallback" /t REG_DWORD /d 0 /f
