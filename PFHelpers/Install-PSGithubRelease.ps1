[CmdletBinding()]
Param(
    [string]$GithubRepo = "gjonespf/PSProfile",
    [string]$DestinationPath = "${$Home}/Documents/WindowsPowerShell",
    [string]$ReleaseFilenamePattern="*.zip",
    [bool]$PreRelease=$false
)
{
    #$filenamePattern = "*x86_64.zip"
    $filenamePattern = $ReleaseFilenamePattern
    $pathExtract = "$DestinationPath/PFProfile"
    $innerDirectory = $true

    if ($PreRelease) {
        $releasesUri = "https://api.github.com/repos/$GithubRepo/releases"
        $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri)[0].assets | Where-Object name -like $filenamePattern ).browser_download_url
    }
    else {
        $releasesUri = "https://api.github.com/repos/$GithubRepo/releases/latest"
        $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object name -like $filenamePattern ).browser_download_url
    }

    $pathZip = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath $(Split-Path -Path $downloadUri -Leaf)

    Invoke-WebRequest -Uri $downloadUri -Out $pathZip

    Remove-Item -Path $pathExtract -Recurse -Force -ErrorAction SilentlyContinue

    if ($innerDirectory) {
        $tempExtract = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath $((New-Guid).Guid)
        Expand-Archive -Path $pathZip -DestinationPath $tempExtract -Force
        Move-Item -Path "$tempExtract\*" -Destination $pathExtract -Force
        Remove-Item -Path $tempExtract -Force -Recurse -ErrorAction SilentlyContinue
    }
    else {
        Expand-Archive -Path $pathZip -DestinationPath $pathExtract -Force
    }

    Remove-Item $pathZip -Force
}
