#Step 1
#Variable to Modify
$SubscriptionId = ""
$ResourceGroupName = ""
#The Ressource Group of your storage Account
$StorageAccountName = ""
$AzufileShareName = ""
$StorageAccountKey = ""
$ADDSname = ""


#Step 2
#Module and Connection
Install-Module AZ
Import-Module AZ
Install-Module azuread
Import-Module azuread
#Connection Needed for Azure 
Connect-AzAccount
Select-AzSubscription -SubscriptionId $SubscriptionId
#Connection Needed for Azure AD
Connect-AzureAD

#Step 3
#Variable to not modify
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$UserGroupName = "WVD-Users"
$AdminGroupName = "WVD-Admin"
$ObjectIDGroupUser = (Get-AzADGroup -DisplayName $UserGroupName).id
$ObjectIDGroupAdmin = (Get-AzADGroup -DisplayName $AdminGroupName).id
$rolenameAdmin = "Storage File Data SMB Share Elevated Contributor"
$rolenameUser = "Storage File Data SMB Share Contributor"
$DirectoryID= "T:\Profiles"
$Directory= "Profiles"

#Step 4
#Add the Azure Right to the storage Account
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

#Step 5
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

#Step 6 Directory and NTFS
New-Item -Path $DirectoryID -ItemType Directory

#Set the NTFS Right
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName\$Directory /inheritance:d
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName\$Directory /remove "Creator Owner"
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName\$Directory /grant 'CREATOR OWNER:(OI)(CI)(IO)(M)'
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName\$Directory /remove "Authenticated Users" 
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName\$Directory /remove "Builtin\Users"
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName\$Directory /grant $ADDSname\"WVD-Users":M
icacls \\$StorageAccountName.file.core.windows.net\$AzufileShareName\$Directory /grant $ADDSname\"WVD-Admin":F
