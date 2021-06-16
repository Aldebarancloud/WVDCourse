#Step 1
#Variable to Modify
$SubscriptionId = ""
$ResourceGroupName = ""
#The Ressource Group of your storage Account
$StorageAccountName = ""
$AzufileShareName = ""
$StorageAccountKey = ""


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
#Variable to not modify"
$xmllocation= "\\$StorageAccountName.file.core.windows.net\$AzurefileShareName\$Directory"

#Step 4
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

#Step 4 Directory Creation for Teams Exclusion
#Variable to not modify
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$DirectoryID= "T:\Teams"
$Directory= "Teams"
New-Item -Path $DirectoryID -ItemType Directory

#Step 5 Download the Xmlredirection
#Variable to not modify"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
$xmllocation= "\\$StorageAccountName.file.core.windows.net\$AzurefileShareName\$Directory"
$xmlurl= "https://raw.githubusercontent.com/Aldebarancloud/WVDCourse/main/redirections.xml"
$connectionString= "\\$StorageAccountName.file.core.windows.net\$AzurefileShareName\$Directory"

Invoke-WebRequest -Uri $xmlurl -OutFile $xmllocation

#Step 6 Fslogix regedit configuration
Push-Location 
Set-Location HKLM:\SOFTWARE\

New-ItemProperty `
    -Path HKLM:\Software\FSLogix\Profiles `
    -Name "RedirXMLSourceFolder" `
    -Value $connectionString `
    -PropertyType MultiString `
    -Force 
