Install-Module azuread

Import-Module azuread

Connect-AzureAD

Get-AzureADGroup -Filter "DisplayName eq 'WVD-Users'" 

Get-AzureADGroup -Filter "DisplayName eq 'WVD-Admin'" 

Get-AzureADGroup -Filter "DisplayName eq 'AAD DC Administrators'" 


$userUPN=""
$groupNameUser="WVD-Users"
Add-AzureADGroupMember -RefObjectId (Get-AzureADUser | Where { $_.UserPrincipalName -eq $userUPN }).ObjectID -ObjectId (Get-AzureADGroup | Where { $_.DisplayName -eq $groupNameUser }).ObjectID
#Add user to the WVD-Users with UPN Value

$userUPN=""
$groupNameAdmin="WVD-Admin"
Add-AzureADGroupMember -RefObjectId (Get-AzureADUser | Where { $_.UserPrincipalName -eq $userUPN }).ObjectID -ObjectId (Get-AzureADGroup | Where { $_.DisplayName -eq $groupNameUser }).ObjectID
#Add user to the WVD-Admin with UPN Value

$userUPN=""
$groupNameUser="AAD DC Administrators"
Add-AzureADGroupMember -RefObjectId (Get-AzureADUser | Where { $_.UserPrincipalName -eq $userUPN }).ObjectID -ObjectId (Get-AzureADGroup | Where { $_.DisplayName -eq $groupNameUser }).ObjectID
#Add user to the ADDS Admin with UPN Value mandatory to perform the azure Domain join with ADDS