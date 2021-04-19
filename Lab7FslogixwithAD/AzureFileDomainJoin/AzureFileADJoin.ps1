#Variable
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$AzFileSource = "https://github.com/Azure-Samples/azure-files-samples/releases/download/v0.2.3/AzFilesHybrid.zip"
$locationAzFiledownload = "D:\AzFilesHybrid.zip"
$folder = "D:\AzFileHybrid"
$SubscriptionId = "f487f0e2-e87a-4545-bfd9-970d04b4f9d5"
$ResourceGroupName = "AD"
$StorageAccountName = "stofsveo"
$AzufileShareName = "fileamoi"
$StorageAccountKey = "v5vxyLD8qgBqBBu1D0klbPwPxMfxyhm/NmRJcq+uFZfPwvHzSJZRvonuoHWKikGzEl5rqD7oGVcanYKT7dWPsA=="
Install-Module AZ
Import-Module AZ
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

#Folder Creation for Unzip
New-Item -Path $folder -ItemType Directory

#Download AzFile and Unzip AzFile
Invoke-WebRequest -Uri $AzFileSource -OutFile $locationAzFiledownload
Expand-Archive D:\AzFilesHybrid.zip -DestinationPath D:\AzFileHybrid

#Set the Location
cd D:\AzFileHybrid

# Navigate to where AzFilesHybrid is unzipped and stored and run to copy the files into your path
.\CopyToPSPath.ps1

#Import AzFilesHybrid module
Import-Module -Name AzFilesHybrid

#Connect to the Azure Account and Select the Correct Subscription
Connect-AzAccount
Select-AzSubscription -SubscriptionId $SubscriptionId

# Register the target storage account with your active directory environment
Join-AzStorageAccountForAuth `
        -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName `
        -DomainAccountType "ComputerAccount" `
        #-DomainAccountType "ServiceLogonAccount"
        -OrganizationalUnitDistinguishedName "OU=WVD-Users,DC=demoad,DC=com" `
        #Modify the DC value by your domain name and his extention (exemple DC=ad,DC=.com)
        -EncryptionType "<AES256/RC4/AES256,RC4>" `


Debug-AzStorageAccountAuth -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName -Verbose
#You can run the Debug-AzStorageAccountAuth cmdlet to conduct a set of basic checks on your AD configuration with the logged on AD user. This cmdlet is supported on AzFilesHybrid v0.1.2+ version. For more details on the checks performed in this cmdlet, see Azure Files Windows troubleshooting guide.

# Confirm the feature is enabled
$storageaccount = Get-AzStorageAccount `
        -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName

$storageAccount.AzureFilesIdentityBasedAuth.DirectoryServiceOptions

$storageAccount.AzureFilesIdentityBasedAuth.ActiveDirectoryProperties

#  Run the code below to test the connection and mount the share
$connectTestResult = Test-NetConnection -ComputerName "$StorageAccountName.file.core.windows.net" -Port 445
if ($connectTestResult.TcpTestSucceeded)
{
  net use T: "\\$StorageAccountName.file.core.windows.net\$AzufileShareName" /user:Azure\$StorageAccountName $StorageAccountKey
} 
else 
{
  Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN,   Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}

