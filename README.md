# PSProfile

```pwsh
# To fix needing TLS1.2 by default
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

# First install/copy local
cd ~
# Ensure there's a new powershell dir
$_ = New-Item -ItemType Directory -Path ~\Documents\WindowsPowerShell -Force
$bootstrapUrl = "https://raw.githubusercontent.com/gjonespf/PSProfile/master/PFHelpers/Install-PSGithubRelease.ps1"
Invoke-WebRequest -Uri $bootstrapUrl -Out "Install-PSGithubRelease.ps1"

# All the defaults are set for this to "Just Work (tm)":
. ./Install-PSGithubRelease.ps1
Install-PSGithubRelease

# Or if you want the absolute bleeding edge:
Install-PSGithubRelease -PreRelease $true

# Then add to profile
notepad $Profile

# Add the following:
# . "~/Documents/WindowsPowerShell/PFProfile/PFHelpers/PFHelpers.ps1"

# To update later, simply run:
Install-PSGithubRelease

```
