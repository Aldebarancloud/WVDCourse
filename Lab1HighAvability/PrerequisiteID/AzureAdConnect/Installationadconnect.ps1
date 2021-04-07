[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$SrcAdConnect = "https://download.microsoft.com/download/B/0/0/B00291D0-5A83-4DE7-86F5-980BC00DE05A/AzureADConnect.msi"
$location = "C:\Windows\Temp\AzureADConnect.msi"

Start-BitsTransfer -Source $SrcAdConnect -Destination $location
C:\Windows\Temp\AzureADConnect.msi /quiet