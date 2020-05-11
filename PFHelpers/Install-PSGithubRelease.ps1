function Install-PSGithubRelease {
    [CmdletBinding()]
    Param(
        [string]$GithubRepo = "gjonespf/PSProfile",
        [string]$DestinationPath = (Join-Path $Home -ChildPath "/Documents/WindowsPowerShell"),
        [string]$ReleaseFilenamePattern="*.zip",
        [bool]$PreRelease=$false,
        [bool]$UseZipball=$true
    )

    #$filenamePattern = "*x86_64.zip"
    $filenamePattern = $ReleaseFilenamePattern
    $pathExtract = Join-Path $DestinationPath -ChildPath "PFProfile"
    $innerDirectory = $true

    # To fix needing TLS1.2 by default
    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

    # Check repo exists
    # GET /repos/:owner/:repo
    $repoExistsUri = "https://api.github.com/repos/$GithubRepo"
    $existsResult = Invoke-RestMethod -Method GET -Uri $repoExistsUri
    if(!$existsResult) {
        throw "Could not find correct repo ($GithubRepo) please check repo exists and is public and try again"
    }

    # https://developer.github.com/v3/repos/releases/#get-the-latest-release
    # GET /repos/:owner/:repo/releases/latest
    if ($PreRelease) {
        $releasesUri = "https://api.github.com/repos/$GithubRepo/releases"
        if($UseZipball) {
            $downloadUri = ((Invoke-RestMethod -ErrorAction SilentlyContinue -Method GET -Uri $releasesUri)[0].zipball_url )
        } else {
            $downloadUri = ((Invoke-RestMethod -ErrorAction SilentlyContinue -Method GET -Uri $releasesUri)[0].assets | Where-Object name -like $filenamePattern ).browser_download_url
        }
    }
    else {
        $releasesUri = "https://api.github.com/repos/$GithubRepo/releases/latest"
        if($UseZipball) {
            $downloadUri = ((Invoke-RestMethod -ErrorAction SilentlyContinue -Method GET -Uri $releasesUri)[0].zipball_url )
        } else {
            $downloadUri = ((Invoke-RestMethod -ErrorAction SilentlyContinue -Method GET -Uri $releasesUri).assets | Where-Object name -like $filenamePattern ).browser_download_url
        }
    }

    if($downloadUri)
    {
        # releaseTemp
        $tempPath = $([System.IO.Path]::GetTempPath())
        $releaseVersion = $(Split-Path -Path $downloadUri -Leaf)
        $releaseTempRelative = $GithubRepo + "/" + $(Split-Path -Path $downloadUri -Leaf)
        $releasePath = Join-Path -Path $tempPath -ChildPath $GithubRepo
        $pathZip = Join-Path -Path $tempPath -ChildPath "$releaseTempRelative.zip"
        $_ = New-Item -ItemType Directory -Path $releasePath -Force -ErrorAction SilentlyContinue
        Write-Host "Downloading $GithubRepo release: $releaseVersion"
        Invoke-WebRequest -Uri $downloadUri -Out $pathZip

        Remove-Item -Path $pathExtract -Recurse -Force -ErrorAction SilentlyContinue
        $_ = New-Item -ItemType Directory -Path $pathExtract -Force

        if ($innerDirectory) {
            $tempExtract = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath $((New-Guid).Guid)
            Expand-Archive -Path $pathZip -DestinationPath $tempExtract -Force
            if(Test-Path $tempExtract) {
                $innerDir = Get-ChildItem $tempExtract | Select-Object -f 1 -ExpandProperty FullName
                # Write-Host "$tempExtract"
                Move-Item -Path "$innerDir\*" -Destination $pathExtract -Force
                Remove-Item -Path $tempExtract -Force -Recurse -ErrorAction SilentlyContinue
            } else {
                throw "Could not find output from extration process in temp directory: $tempExtract"
            }
        }
        else {
            Expand-Archive -Path $pathZip -DestinationPath $pathExtract -Force
        }

        Write-Host "Release: $GithubRepo $releaseVersion has been installed"

        Remove-Item $pathZip -Force
    }
    else {
        Write-Warning "Could not get latest release, please check the repo has an available release and try again ($GithubRepo)"
    }
}
