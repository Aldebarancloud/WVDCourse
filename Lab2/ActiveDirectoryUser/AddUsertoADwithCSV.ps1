#############################################
#    Create a New Active Directory Group    #
#############################################
Import-Module ActiveDirectory
$AdGroup = "VDIuser"
$AdGroup2 = "VDIadmin"
$Path = "OU=WVD-Users,DC=demoad,DC=com"

##change the DC value by your domain Name

New-AdGroup -Name $AdGroup -GroupScope Global -Path $Path
New-AdGroup -Name $AdGroup2 -GroupScope Global -Path $Path
#Value hard coded for the Path for demo purpose#

#############################################
#    Create a New Active Directory Group    #
#############################################
$CSV= "https://raw.githubusercontent.com/Aldebarancloud/WVDCourse/main/Lab2/ActiveDirectoryUser/UserCSVv2.csv"
$locationCSV = "D:\"

Start-BitsTransfer -Source $CSV -Destination $locationCSV
#modify the CVS
#Column company modify by the Domain Name without the extention
#Column ou modify the DC value by your domain name and extention


# Store the data from NewUsersFinal.csv in the $ADUsers variable
$ADUsers = Import-Csv D:\UserCSV.csv -Delimiter ";"
#modify the path if you have change the location for the download if not you can leave it 

# Define UPN
$UPN = "demoad.com"

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers) {

    #Read user data from each field in each row and assign the data to a variable as below
    $username = $User.username
    $password = $User.password
    $firstname = $User.firstname
    $lastname = $User.lastname
    $initials = $User.initials
    $OU = $User.ou #This field refers to the OU the user account is to be created in
    $email = $User.email
    $streetaddress = $User.streetaddress
    $city = $User.city
    $zipcode = $User.zipcode
    $state = $User.state
    $telephone = $User.telephone
    $jobtitle = $User.jobtitle
    $company = $User.company
    $department = $User.department

    # Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # If user does exist, give a warning
        Write-Warning "A user account with username $username already exists in Active Directory."
    }
    else {

        # User does not exist then proceed to create the new user account
        # Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$UPN" `
            -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -Initials $initials `
            -Enabled $True `
            -DisplayName "$lastname, $firstname" `
            -Path $OU `
            -City $city `
            -PostalCode $zipcode `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) -PasswordNeverExpires $true
        # If user is created, show message.
        Write-Host "The user account $username is created." -ForegroundColor Cyan
    }
}

Read-Host -Prompt "Press Enter to exit"

###################################
#    Add Users to the AD Group    #
###################################

Add-AdGroupMember -Identity $AdGroup -Members Batman, Alfred.Pennyworth, Robin, Dick.Grayson, Batgirl, RedRobin, Nigthwing, Jason.Todd, Damian.Wayne, Tim.Drake, Barbara.Gordon, Catwoman, Selina.Kyle, RedHood, Ace.LeBatChien, Batwoman, Kathy.Kane, Terry.McGinnis, Joker, Superman, Harley.Quinn, GreenArrow, Aquaman, Poison.Ivy, Pingouin, Double.Face, Titans, Teen.Titans   