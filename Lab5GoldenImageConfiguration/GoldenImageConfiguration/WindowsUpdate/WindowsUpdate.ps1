Install-Module PSWindowsUpdate

Get-Command -module PSWindowsUpdate

Add-WUServiceManager -MicrosoftUpdate

Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
