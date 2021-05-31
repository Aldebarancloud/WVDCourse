#Install the Extention for your GPU card

#Variables to modify
$RessourceGroupName = "<your-VM-Resource-Group>"
$VMname = "<your-VM-Name>"
$location = "<your-VM-location>"
$SubscriptionId = "<your-subscription-id-here>"

#Connect to Azure
#Module Installation
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module AZ
Import-Module AZ
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

#Connect to thge Azure Subscription

Connect-AzAccount
Select-AzSubscription -SubscriptionId $SubscriptionId

#Click on your VM

#Click on Extention
#Select AMD Extention based on the GPU inside your VM
#NVv4 Series = AMD Radeon Instinct MI25 = AMD Extention

#Variable to not modify
$Publisher = "Microsoft.HpcCompute"
$ExtentionNameAMD = "AmdGpuDriverWindows"
$ExtentionTypeAMD = "AmdGpuDriverWindows"

#Install the Extention AMD

Set-AzVMExtension -ResourceGroupName $RessourceGroupName -Location $location -VMName $VMname -ExtensionName $ExtentionNameAMD -Publisher $Publisher -Type $ExtentionTypeAMD -TypeHandlerVersion "1.0"

#Check the Extention Installation for AMD

Get-AzVMExtension -ResourceGroupName $RessourceGroupName -VMName $VMname -Name $ExtentionNameAMD

#Restart your VM
Restart-AzVM -ResourceGroupName $RessourceGroupName -Name $VMname

Get-AzVM ` -ResourceGroupName $RessourceGroupName ` -Name $VMname ` -Status