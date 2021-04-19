[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#CSVUser
$CSVUser = "https://raw.githubusercontent.com/Aldebarancloud/WVDCourse/main/Lab2withADDS/AzureActiveDirectoryUser/UserCSVforAzureAD.csv"

#CSVAddUsertoaGroup
$CSVAddUsertoaGroup = "https://raw.githubusercontent.com/Aldebarancloud/WVDCourse/main/Lab2withADDS/AzureActiveDirectoryAddUsertoaGroup/AddUsertoaGroupCSVforAzureAD.csv"

#Folder Name
$folder = "C:\Lab2WVD"
$locationCSVUser = "C:\Lab2WVD\UserCSVforAzureAD.csv"
$locationCSVAddUsertoaGroup = "C:\Lab2WVD\AddUsertoaGroupCSVforAzureAD.csv"


#Folder Creation
New-Item -Path $folder -ItemType Directory

#Download CSVUser
Invoke-WebRequest -Uri $CSVUser -OutFile $locationCSVUser

#Download CSVAddUsertoaGroup
Invoke-WebRequest -Uri $CSVAddUsertoaGroup -OutFile $locationCSVAddUsertoaGroup