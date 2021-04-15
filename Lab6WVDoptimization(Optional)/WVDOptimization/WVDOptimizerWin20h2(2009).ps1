################################
#    Download WVD Optimizer    #
################################
New-Item -Path C:\ -Name Optimize -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = "C:\OptimizeWVD\"
$WVDOptimizeURL = 'https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/archive/refs/heads/main.zip'
$WVDOptimizeInstaller = "Windows_10_VDI_Optimize-master.zip"
Invoke-WebRequest `
    -Uri $WVDOptimizeURL `
    -OutFile "$Localpath$WVDOptimizeInstaller"


###############################
#    Prep for WVD Optimize    #
###############################
Expand-Archive `
    -LiteralPath "C:\OptimizeWVD\Windows_10_VDI_Optimize-master.zip" `
    -DestinationPath "$Localpath" `
    -Force `
    -Verbose
Set-Location -Path C:\OptimizeWVD\Virtual-Desktop-Optimization-Tool-main


#################################
#    Run WVD Optimize Script    #
#################################
New-Item -Path C:\Optimize\ -Name installoptimize.log -ItemType File -Force
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
add-content c:\Optimize\installoptimize.log "Starting Optimizations"  
.\Win10_VirtualDesktop_Optimize.ps1 -WindowsVersion 2009 -Restart -Verbose