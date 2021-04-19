Install-Module azuread
Import-Module azuread
Connect-AzureAD

#Variables
$ObjectIDGroupUser = ""
$ObjectIDGroupAdmin = ""
$subscription = "<subscription-id>"
$ResourceGroup = "<resource-group-name>"
$StorageAccount = "<Storage-account-name>"
$fileShare = "<Azure-FileShare-name>"
$rolenameAdmin = "Storage File Data SMB Share Elevated Contributor"
$rolenameUser = "Storage File Data SMB Share Contributor"
$UserGroupName = "WVD-Admin"
$AdminGroupName = "WVD-User"

(Get-AzADGroup -DisplayName $UserGroupName).id
#copy past the value on the variable $ObjectIDGroupUser

(Get-AzADGroup -DisplayName $AdminGroupName).id
#copy past the value on the variable $ObjectIDGroupAdmin

#Get the name of the custom role
$FileShareContributorRole = Get-AzRoleDefinition $rolenameAdmin #Use one of the built-in roles: Storage File Data SMB Share Reader, Storage File Data SMB Share Contributor, Storage File Data SMB Share Elevated Contributor
#Constrain the scope to the target file share
$scope = "/subscriptions/$subscription/resourceGroups/$ResourceGroup/providers/Microsoft.Storage/storageAccounts/$StorageAccount/fileServices/default/fileshares/$fileShare"
#Assign the custom role to the target identity with the specified scope.
New-AzRoleAssignment -ObjectId $ObjectIDGroupAdmin -RoleDefinitionName $FileShareContributorRole.Name -Scope $scope

#Get the name of the custom role
$FileShareContributorRole = Get-AzRoleDefinition $rolenameUser #Use one of the built-in roles: Storage File Data SMB Share Reader, Storage File Data SMB Share Contributor, Storage File Data SMB Share Elevated Contributor
#Constrain the scope to the target file share
$scope = "/subscriptions/$subscription/resourceGroups/$ResourceGroup/providers/Microsoft.Storage/storageAccounts/$StorageAccount/fileServices/default/fileshares/$fileShare"
#Assign the custom role to the target identity with the specified scope.
New-AzRoleAssignment -ObjectId $ObjectIDGroupUser -RoleDefinitionName $FileShareContributorRole.Name -Scope $scope