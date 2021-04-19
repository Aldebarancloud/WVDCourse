[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#AzFile Source
$AzFileSource = "https://github.com/Azure-Samples/azure-files-samples/releases/download/v0.2.3/AzFilesHybrid.zip"

#Download Location
$locationAzFiledownload = "D:\AzFilesHybrid.zip"

#Folder Name
$folder = "D:\AzFileHybrid"

#Folder Creation for Unzip
New-Item -Path $folder -ItemType Directory

#Download AzFile
Invoke-WebRequest -Uri $AzFileSource -OutFile $locationAzFiledownload

#Unzip AzFile
Expand-Archive D:\AzFilesHybrid.zip -DestinationPath D:\AzFileHybrid

Install-Module AZ

Import-Module AZ

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

cd D:\AzFileHybrid

.\CopyToPSPath.ps1

Import-Module -Name AzFilesHybrid

Connect-AzAccount

$SubscriptionId = "<your-subscription-id-here>"
$ResourceGroupName = "<resource-group-name-here>"
$StorageAccountName = "<storage-account-name-here>"

Select-AzSubscription -SubscriptionId $SubscriptionId

Join-AzStorageAccountForAuth `
        -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName `
        -DomainAccountType "ComputerAccount" `
        #-DomainAccountType "ServiceLogonAccount"
        -OrganizationalUnitDistinguishedName "<ou-distinguishedname-here>"

# Get the target storage account
$storageaccount = Get-AzStorageAccount `
        -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName

# List the directory service of the selected service account
$storageAccount.AzureFilesIdentityBasedAuth.DirectoryServiceOptions

# List the directory domain information if the storage account has enabled
#AD DS authentication for file shares
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
