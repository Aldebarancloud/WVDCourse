#Variables Remote Desktop WebRTC Redirector Service
$RDWRedirectorSource = "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt"
$locationRDWR = "D:\MsRdcWebRTCSvc_HostSetup_1.0.2006.11001_x64.msi"
$pathRDWR = "D:\MsRdcWebRTCSvc_HostSetup_1.0.2006.11001_x64.msi"

#Download Remote Desktop WebRTC Redirector Service Source
Invoke-WebRequest -Uri $RDWRedirectorSource -OutFile $locationRDWR
#Install Remote Desktop WebRTC Redirector Service Source
Start-Process -FilePath "$pathRDWR" /quiet