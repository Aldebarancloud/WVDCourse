[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#VisualC++ Source x64
$VisualCSource = "https://aka.ms/vs/16/release/vc_redist.x64.exe"
$location = "D:\"
$pathvcc = "D:\vc_redist.x64.exe"

#Download VisualC++ x64
Start-BitsTransfer -Source $VisualCSource -Destination $location
Start-Process -FilePath "$pathvcc" /quiet

#the VM Will restart