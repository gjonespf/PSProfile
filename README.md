# PSProfile

```pwsh
# First install/copy local
cd ~
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
