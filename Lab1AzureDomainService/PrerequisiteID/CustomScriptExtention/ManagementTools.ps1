$LDAP= "RSAT"
$GroupPolicy= "GPMC"

Install-WindowsFeature –Name $LDAP
Install-WindowsFeature –Name $GroupPolicy