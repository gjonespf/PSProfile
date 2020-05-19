function Invoke-Chrome {
    & "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
}

function Get-CurrentPrincipal {
    return [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
}

function Test-AmIAdmin {
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
}

function Invoke-SelfElevate {
    # Self-elevate the script if required
    if (-Not (Test-AmIAdmin)) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
      $CommandLine = " "
      if($MyInvocation.MyCommand.Path) {
          $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
      }
      Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    }
   } else {
      Start-Process -FilePath PowerShell.exe
      # Read-Host 'Press Enter to continue…' | Out-Null
   }
}