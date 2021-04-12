#Install the Extention for your GPU card

#Connect to Azure
#Module Installation
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module AZ
Import-Module AZ
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

#Connect to thge Azure Subscription
$SubscriptionId = "<your-subscription-id-here>"
Connect-AzAccount
Select-AzSubscription -SubscriptionId $SubscriptionId

#Click on your VM

#Click on Extention
#Select Nvidia or AMD Extention based on the GPU inside your VM
#NC Series = Tesla K80 = Nvidia Extention
#NCv2 Series = Tesla P100 = Nvidia Extention
#NCv3 Series = Tesla V100 = Nvidia Extention
#NCasT4_v3 Series = Tesla T4 = Nvidia Extention
#ND Series = Tesla P40 = Nvidia Extention
#NDv2 Series = Tesla V100 NVLINK = Nvidia Extention
#NV Series = Tesla M60 = Nvidia Extention
#NVv3 Series = Tesla M60 = Nvidia Extention

#Variable
$RessourceGroupName = ""
$VMname = ""
$location = ""
$Publisher = "Microsoft.HpcCompute"
$ExtentionNameNvidia = "NvidiaGpuDriverWindows"
$ExtentionTypeNvidia = "NvidiaGpuDriverWindows"

#Install the Extention Nvidia

Set-AzVMExtension -ResourceGroupName $RessourceGroupName -Location $location -VMName $VMname -ExtensionName $ExtentionNameNvidia -Publisher $Publisher -Type $ExtentionTypeNvidia -TypeHandlerVersion "1.3"

#Check the Extention Installation for Nvidia

Get-AzVMExtension -ResourceGroupName $RessourceGroupName -VMName $VMname -Name $ExtentionNameNvidia

#Restart your VM
Restart-AzVM -ResourceGroupName $RessourceGroupName -Name $VMname

Get-AzVM ` -ResourceGroupName $RessourceGroupName ` -Name $VMname ` -Status