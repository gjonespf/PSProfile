function Get-CurrentPrincipal {
    return [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
}

function Test-AmIAdmin {
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
}

<#
.SYNOPSIS
Gets the drive letter of the machine system drive.

.DESCRIPTION
Gets the drive letter of the machine system drive.  Convention for this is the drive named "OS"/"Windows" or the first system drive.

.EXAMPLE
> Get-SystemDrivePath
C:\

.NOTES
General notes
TODO: XPlat
#>
function Get-SystemDrivePath {
    $osDrive = (get-volume) | Where-Object{ $_.FileSystemLabel -match "OS" }
    if($osDrive) {
        return Join-Path -Path ($osDrive.DriveLetter + ":") -ChildPath "/"
    }
    $osDrive = (get-volume) | Where-Object{ $_.FileSystemLabel -match "Windows" }
    if($osDrive) {
        return Join-Path -Path ($osDrive.DriveLetter + ":") -ChildPath "/"
    }
    return Join-Path -Path ($env:SystemDrive[0] + ":") -ChildPath "/"
}

<#
.SYNOPSIS
Gets the drive letter of the machine application drive, defaulting to data if not found.

.DESCRIPTION
Gets the drive letter of the machine application drive.  Convention for this is the drive named "APP"/"APPS".

.EXAMPLE
> Get-ApplicationDrivePath
D:\

.NOTES
General notes
#>
function Get-ApplicationDrivePath {
    $appDrive = (get-volume) | Where-Object{ $_.FileSystemLabel -match "APP" }
    if($appDrive) {
        return Join-Path -Path ($appDrive.DriveLetter + ":") -ChildPath "\"
    }
    $appDrive = (get-volume) | Where-Object{ $_.FileSystemLabel -match "DATA" }
    if($appDrive) {
        return Join-Path -Path ($appDrive.DriveLetter + ":") -ChildPath "\"
    }
    return Join-Path -Path ($env:SystemDrive[0] + ":") -ChildPath "\"
}

<#
.SYNOPSIS
Gets the drive letter of the machine data drive, intended for bulk storage. 

.DESCRIPTION
Gets the drive letter of the machine data drive.  Convention for this is the drive named "DATA".

.EXAMPLE
> Get-DataDrivePath
D:\

.NOTES
General notes
#>
function Get-DataDrivePath {
    $dataDrive = (get-volume) | Where-Object{ $_.FileSystemLabel -match "DATA" }
    if($dataDrive) {
        return Join-Path -Path ($dataDrive.DriveLetter + ":") -ChildPath "\"
    }
    return $env:SystemDrive[0]
}

<#
.SYNOPSIS
Gets the drive letter of the machine temp drive - intended to be a. 

.DESCRIPTION
Gets the drive letter of the machine temp drive.  Convention for this is the drive named "TEMP"/"Temporary Storage".
Defaults alternatively to data drive or system drive if not found.

.EXAMPLE
> Get-TempDrivePath
D:\

.NOTES
General notes
#>
function Get-TempDrivePath {
    $tempDrive = (get-volume) | Where-Object{ $_.FileSystemLabel -match "TEMP" }
    if($tempDrive) {
        return Join-Path -Path ($tempDrive.DriveLetter + ":") -ChildPath "\"
    }
    $dataDrive = (get-volume) | Where-Object{ $_.FileSystemLabel -match "DATA" }
    if($dataDrive) {
        return Join-Path -Path ($dataDrive.DriveLetter + ":") -ChildPath "\"
    }
    return Join-Path -Path ($env:SystemDrive[0] + ":") -ChildPath "\"
}
