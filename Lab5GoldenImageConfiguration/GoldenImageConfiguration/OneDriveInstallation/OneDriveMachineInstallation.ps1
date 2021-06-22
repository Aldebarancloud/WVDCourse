#Uninstall One Drive current version
#Do it manually through app and programs

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

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

#Variables
$OneDriveSource = "https://go.microsoft.com/fwlink/?linkid=844652"
$locationOneDrivedownload = "C:\temp\OneDriveSetup.exe"

#Download OneDrive Per-Machine
Invoke-WebRequest -Uri $OneDriveSource -OutFile $locationOneDrivedownload

#Install OneDrive
C:\OneDriveSetup.exe /allusers
