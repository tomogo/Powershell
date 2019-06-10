#REQUIRES -Version 2.0

<#
.SYNOPSIS
    Easy script for backup your file to some path.
.DESCRIPTION
    It has two parameters (Source and Destination Directory).
    All from source directory will be copared by last write time with destination directory
    and if there are some differences it will be copied from source into the destination.
.NOTES
    File Name      : run-backup.ps1
    Author         : Tomáš Janovský (tomas.janovsky@gmail.com)
    Prerequisite   : PowerShell V2 over Vista and upper.
    Copyright      : Open Source
.LINK
    Script posted over:
    https://github.com/tomogo/Powershell
.EXAMPLE
    Use:  run-backup.ps SourceDir DestinationDir
.EXAMPLE
    Like: run-backup.ps C:\Users\MyLogin\Documents D:\Backup
    Or:   run-backup.ps C:\Users\MyLogin\Documents \\MY-SERVER\Share\Backup"
#>

if ($Args.Count -eq 0){
    Write-Host "Missing parameters:

    Use:  run-backup.ps SourceDir DestinationDir

    Like: run-backup.ps C:\Users\MyLogin\Documents D:\Backup
    Or:   run-backup.ps C:\Users\MyLogin\Documents \\MY-SERVER\Share\Backup"
    exit
} elseif ($Args.Count -eq 2) {
    $srcDir=$Args[0]
    $dstDir=$Args[1]
} else {
    Write-Host "Wrong numbers of parameters!"
    exit
}


$srcDir.TrimEnd("\")| Out-Null
$dstDir.TrimEnd("\")| Out-Null

Write-Host Starting backup of $srcDir into $dstDir

$newDirs=0
$transferredFiles=0
$updatedFiles=0

Get-ChildItem -Path $srcDir -Recurse -Force -ErrorAction SilentlyContinue -Directory | ForEach-Object{
    #$dstFile=$dstDir + "\" + $_.FullName.TrimStart($srcDir)
    $dstFile=$dstDir + "\" + $_.FullName.Remove(0,$srcDir.Length+1)
    $dstFileExists=Test-Path -LiteralPath $dstFile
    if (!$dstFileExists) {
        Write-Host "Creating Directory: " $_.FullName " do: " $dstFile
        Copy-Item -LiteralPath $_.FullName -Destination $dstFile -Force
        $newDirs++
    }
}

Get-ChildItem -Path $srcDir -Recurse -Force -ErrorAction SilentlyContinue -File | ForEach-Object{
    #$dstFile=$dstDir + "\" + $_.FullName.TrimStart($srcDir)
    $dstFile=$dstDir + "\" + $_.FullName.Remove(0,$srcDir.Length+1)
    $dstFileExists=Test-Path -LiteralPath $dstFile
    if (!$dstFileExists) {
        Write-Host "Transferring: " $_.FullName " to: " $dstFile
        Copy-Item -LiteralPath $_.FullName -Destination $dstFile -Force
        $transferredFiles++
    } else {
        $overFile=Get-ChildItem -LiteralPath $dstFile
        if ($_.LastWriteTime -ne $overFile.LastWriteTime) {
            Write-Host "Updating: " $_.FullName " to: " $dstFile
            Copy-Item -LiteralPath $_.FullName -Destination $dstFile -Force
            $updatedFiles++
        }
    }
}

Write-Host Bakup finished.
Write-Host
Write-Host New directories $newDirs
Write-Host New files $transferredFiles
Write-Host Updated files $updatedFiles
