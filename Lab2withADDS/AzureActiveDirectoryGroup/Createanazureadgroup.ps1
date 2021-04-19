Install-Module azuread

Import-Module azuread

Connect-AzureAD

New-AzureADGroup -Description "WVD-Users" -DisplayName "WVD-Users" -MailEnabled $false -SecurityEnabled $true -MailNickName "WVD-Users"

New-AzureADGroup -Description "WVD-Admin" -DisplayName "WVD-Admin" -MailEnabled $false -SecurityEnabled $true -MailNickName "WVD-Admin"

