Install-Module AZ

Import-Module AZ

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

Connect-AzAccount

$location = "<your-Location-here>"
$SubscriptionId = "<your-subscription-id-here>"
$ResourceGroupName = "<resource-group-name-here>"
$vmName = "<Vm-name-here>"
$snapshotName = "<Snapshot Name>"

$vm = Get-AzVM -Name $vmName `
               -ResourceGroupName $ResourceGroupName

$snapshotConfig =  New-AzSnapshotConfig -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
                                        -Location $location `
                                        -CreateOption copy `
                                        -SkuName Standard_LRS

$timestamp = Get-Date -Format yyMMddThhmmss
$snapshotName = ($vmName+$timestamp)
 
New-AzSnapshot -Snapshot $snapshotConfig `
               -SnapshotName $snapshotName `
               -ResourceGroupName $resourceGroupName