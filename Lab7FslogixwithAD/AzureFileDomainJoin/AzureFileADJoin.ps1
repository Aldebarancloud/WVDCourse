#Variable
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$AzFileSource = "https://github.com/Azure-Samples/azure-files-samples/releases/download/v0.2.3/AzFilesHybrid.zip"
$locationAzFiledownload = "D:\AzFilesHybrid.zip"
$folder = "D:\AzFileHybrid"
$SubscriptionId = "f487f0e2-e87a-4545-bfd9-970d04b4f9d5"
$ResourceGroupName = "AD"
$StorageAccountName = "azurefilefslogix"
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
        -OrganizationalUnitDistinguishedName "OU=WVD-Users,DC=demoad,DC=com"
        #Modify the DC value by your domain name and his extention (exemple DC=ad,DC=.com)

# Confirm the feature is enabled
$storageaccount = Get-AzStorageAccount `
        -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName

$storageAccount.AzureFilesIdentityBasedAuth.DirectoryServiceOptions

$storageAccount.AzureFilesIdentityBasedAuth.ActiveDirectoryProperties

#Assign the Permission in your FileShare#
#Go to your Azure FileShare on the azure Portal#
#Go to IAM#
#Add a Role Assignment#
#SMB Share Elevated Contributor to the Admin#
#SMB Share Contributor to the WVD users or WVD Group#

# Mount the file share as supper user

#Define parameters
$StorageAccountName = "<storage-account-name-here>"
$ShareName = "<share-name-here>"
$StorageAccountKey = "<account-key-here>"

#  Run the code below to test the connection and mount the share
$connectTestResult = Test-NetConnection -ComputerName "$StorageAccountName.file.core.windows.net" -Port 445
if ($connectTestResult.TcpTestSucceeded)
{
  net use T: "\\$StorageAccountName.file.core.windows.net\$ShareName" /user:Azure\$StorageAccountName $StorageAccountKey
} 
else 
{
  Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN,   Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}

#Go the File That you mount#
#Create a Folder i call mine "Profiles"#
#Go to the Properties of this folder#
#Go to the security#
#Go to Advanced#
#Click on Disable Inheritance#
#Click on Convert Inherited permissions into explicit permissions on this object#
#Remove "Authenticated Users"#
#Remove "Users"#
#Click on CREATOR OWNER and change the basic permissions to modify (uncheck the box full control)#
#Click on Add#
#Click on Select a principal#
#Looking for your group with your WVD users mine is "VDI-Users"#
#Assign the modify permissions to your group#
#Modify the box Applies to with "This folder only"#
#Click Apply#

# Path to the file share
# Replace drive letter, storage account name and share name with your settings
# "\\<StorageAccountName>.file.core.windows.net\<ShareName>"
