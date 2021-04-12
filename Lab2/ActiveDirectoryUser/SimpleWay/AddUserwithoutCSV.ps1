##################################################
# Add AD Users
##################################################

# Set values for your environment
$numUsers = "10"
$userPrefix = "WVDUser"
$passWord = ""
#exemple Demowvd2022!
$userDomain = ""
#put your Domain Name
#exemple demoad.com


# Import the AD Module
Import-Module ActiveDirectory

# Convert the password to a secure string
$UserPass = ConvertTo-SecureString -AsPlainText "$passWord" -Force

#Add the users
for ($i=0; $i -le $numUsers; $i++) {
$newUser = $userPrefix + $i
New-ADUser -name $newUser -SamAccountName $newUser -UserPrincipalName $newUser@$userDomain -GivenName $newUser -Surname $newUser -DisplayName $newUser `
-AccountPassword $userPass -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true
}

##################################################
# Create a New Group and add the Users to it
##################################################
$AdGroup = "VDIuser"
$AdGroup2 = "VDIadmin"

NEW-ADGroup –name $AdGroup –groupscope Global
NEW-ADGroup –name $AdGroup2 –groupscope Global

Get-ADUser -Filter 'Name -like "WVDUser*"'| ForEach-Object -process {Add-ADGroupMember -identity $AdGroup -Members $_.SamAccountName}