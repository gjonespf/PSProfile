# PSProfile

```pwsh
# First install/copy local
cd ~
$bootstrapUrl = ""
Invoke-WebRequest -Uri $bootstrapUrl -Out "Install-PSGithubRelease.ps1"
# All the defaults are set for this to "Just Work (tm)"
./Install-PSGithubRelease.ps1

# Then add to profile
notepad $Profile

# Add the following:
# . ./PFProfile/PFHelpers.ps1

# To update later, simply run:
Install-PSGithubRelease

```
