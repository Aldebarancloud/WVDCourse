$LDAP= "RSAT-ADDS"
$GroupPolicy= "GPMC"

Add-WindowsFeature -Name $LDAP
Add-WindowsFeature -Name $GroupPolicy

Install-WindowsFeature –Name $LDAP
Install-WindowsFeature –Name $GroupPolicy