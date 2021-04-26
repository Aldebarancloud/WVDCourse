#Module
Install-Module AZ
Import-Module AZ
Install-Module azuread
Import-Module azuread

#Connection Needed for Azure 
$SubscriptionId = ""
Connect-AzAccount
Select-AzSubscription -SubscriptionId $SubscriptionId

#Connection Needed for Azure AD
Connect-AzureAD
$UserGroupName = "VDIuser"
$AdminGroupName = "VDIadmin"

(Get-AzADGroup -DisplayName $UserGroupName).id
#copy past the value on the variable $ObjectIDGroupUser

(Get-AzADGroup -DisplayName $AdminGroupName).id
#copy past the value on the variable $ObjectIDGroupAdmin

#Variable
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$AzFileSource = "https://github.com/Azure-Samples/azure-files-samples/releases/download/v0.2.3/AzFilesHybrid.zip"
$locationAzFiledownload = "D:\AzFilesHybrid.zip"
$folder = "D:\AzFileHybrid"
$ResourceGroupName = ""
$StorageAccountName = ""
$AzufileShareName = ""
$StorageAccountKey = ""
$rolenameAdmin = "Storage File Data SMB Share Elevated Contributor"
$rolenameUser = "Storage File Data SMB Share Contributor"
$AdminGroupName = "WVD-Admin"
$UserGroupName = "WVD-User"
$ObjectIDGroupUser = ""
$ObjectIDGroupAdmin = "6"
$domainname = ""
$OUUsers = "WVD-Users"

#Modify the execution Policy
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

# Register the target storage account with your active directory environment
Join-AzStorageAccountForAuth `
        -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName `
        -DomainAccountType "ComputerAccount" `
        #-DomainAccountType "ServiceLogonAccount"
        -OrganizationalUnitDistinguishedName "OU=WVD-Users,DC=demoad,DC=com"
        #Modify the DC value by your domain name and his extention (exemple DC=ad,DC=.com)
#

$FileShareContributorRole = Get-AzRoleDefinition $rolenameAdmin 
#Useone of the built-in roles: Storage File Data SMB Share Reader, Storage File Data SMB Share Contributor, Storage File Data SMB Share Elevated Contributor
#Constrain the scope to the target file share
$scope = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Storage/storageAccounts/$StorageAccountName/fileServices/default/fileshares/$AzufileShareName"
#Assign the custom role to the target identity with the specified scope.
New-AzRoleAssignment -ObjectId $ObjectIDGroupAdmin -RoleDefinitionName $FileShareContributorRole.Name -Scope $scope

#Get the name of the custom role
$FileShareContributorRole = Get-AzRoleDefinition $rolenameUser #Use one of the built-in roles: Storage File Data SMB Share Reader, Storage File Data SMB Share Contributor, Storage File Data SMB Share Elevated Contributor
#Constrain the scope to the target file share
$scope = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Storage/storageAccounts/$StorageAccountName/fileServices/default/fileshares/$AzufileShareName"
#Assign the custom role to the target identity with the specified scope.

New-AzRoleAssignment -ObjectId $ObjectIDGroupUser -RoleDefinitionName $FileShareContributorRole.Name -Scope $scope

Debug-AzStorageAccountAuth -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName -Verbose
#You can run the Debug-AzStorageAccountAuth cmdlet to conduct a set of basic checks on your AD configuration with the logged on AD user. This cmdlet is supported on AzFilesHybrid v0.1.2+ version. For more details on the checks performed in this cmdlet, see Azure Files Windows troubleshooting guide.

# Confirm the feature is enabled
$storageaccount = Get-AzStorageAccount `
        -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName
#
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

#Set the NTFS
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName /grant $domainname\"VDIUser":F
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName /grant $domainname\"VDIAdmin":F
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName /grant "CREATOR OWNER":(OI)(CI)(IO)(M)
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName /remove "Authenticated Users" 
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName /remove "Builtin\Users"


