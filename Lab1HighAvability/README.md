# Prerequisite ID:

- Creation of two Domain with an Avaibility Set
Creation of two Data Disks
Creation of two OU (WVD-Users and WVD-Hosts)

- Creation of one VM to Perform the AD Connect
AD join perform on this VM
Active Directory Connect Installation (You need to initiate it to perform the synchronization with the Azure Active Directory)

- Creation of one VM for User Profils repository with FSLogix
AD join perfom on this VM
Creation of One Data Disk to store the Users Profils

- Creation of a Bastion for the administration service without RDP or SSH open on the VMs
