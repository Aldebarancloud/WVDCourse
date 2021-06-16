[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install adobereader -y
choco install googlechrome -y
choco install firefox -y
choco install vlc -y
choco install vscode -y
choco install spotify -y
choco install drawio -y
choco install notepadplusplus.install -y
choco install zoom -y
choco install deepl -y
choco install teamviewer -y
choco install winrar -y

#regedit teams for wvd
reg add "HKLM\SOFTWARE\Microsoft\Teams" /v IsWVDEnvironment /t REG_DWORD /d 1 /f

#Variables
$CSource = "https://aka.ms/vs/16/release/vc_redist.x64.exe"
$RDWRedirectorSource = "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt"
$TeamsSource = "https://statics.teams.cdn.office.net/production-windows-x64/1.4.00.8872/Teams_windows_x64.msi"
$Clocation = "C:\temp\vc_redist.x64.exe"
$RDWRedirectionLocation = "C:\temp\MsRdcWebRTCSvc_HostSetup_1.0.2006.11001_x64.msi"
$TeamsLocation = "C:\temp\Teams_windows_x64.msi"

#log store
[string]$temPAth = 'C:\temp\'

#Folder Creation
if (!(Test-Path -Path $temPAth))
{
    $paramNewItem = @{
        Path      = $temPAth
        ItemType  = 'Directory'
        Force     = $true
    }

    New-Item @paramNewItem
}

#Download C++ Runtime
invoke-WebRequest -Uri $Csource -OutFile $Clocation
Start-Sleep -s 5
#Download RDCWEBRTCSvc
invoke-WebRequest -Uri $RDWRedirectorSource -OutFile $RDWRedirectionLocation
Start-Sleep -s 5
#Download Teams 
invoke-WebRequest -Uri $TeamsSource -OutFile $TeamsLocation
Start-Sleep -s 5

#Install C++ runtime
Start-Process -FilePath $Clocation -ArgumentList '/q', '/norestart'
Start-Sleep -s 10
#Install MSRDCWEBTRCSVC
msiexec /i $RDWRedirectionLocation /q /n
Start-Sleep -s 10
# Install Teams
msiexec /i $TeamsLocation /l*v teamsinstall.txt ALLUSER=1 ALLUSERS=1 /q
Start-Sleep -s 10