# Powershell
If I create comething usefull for public use it will be here.

# run-backup.ps1 - Easy script for backup your files to some destination.
.EXAMPLE
    Use:  run-backup.ps1 SourceDir DestinationDir

    Like:
    run-backup.ps1 C:\Users\MyLogin\Documents D:\Backup
    run-backup.ps1 C:\Users\MyLogin\Documents \\MY-SERVER\Share\Backup"

If you want run it from cmd:

    Like:
    powershell.exe -ExecutionPolicy ByPass -File run-backup.ps1 SourceDir DestinationDir
    Or:
    type run-backup.ps1 | powershell.exe SourceDir DestinationDir
    
