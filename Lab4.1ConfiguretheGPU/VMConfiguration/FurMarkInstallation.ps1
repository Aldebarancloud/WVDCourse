#Connect to your VM

#Install FurMark to run some test on the GPU

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#FurMark Source
$folder = "D:\FuRMark"
New-Item -Path $folder -ItemType Directory

$FurMarkSource = "https://github.com/Aldebarancloud/Training-WVD/blob/master/WVDGPU/FurMark_1.25.0.0_Setup.exe?raw=true"
$locationFurMark = "D:\FuRMark\FurMark_1.25.0.0_Setup.exe"


Start-BitsTransfer -Source $FurMarkSource -Destination $locationFurMark

Start-Process -FilePath "$locationFurMark" /quiet