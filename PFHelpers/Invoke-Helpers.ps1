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

function Invoke-IISManagement {
    # IIS
    $iismgr = "$($env:windir)\system32\inetsrv\InetMgr.exe"
    & $iismgr
}

function Invoke-EventViewer {
    # Event Viewer
    $eventviewer = "$($env:windir)\system32\eventvwr.msc"
    & $eventviewer
}

function Invoke-TaskScheduler {
    # Task Scheduler
    $sched = "$($env:windir)\system32\taskschd.msc"
    & $sched
}

function Invoke-TaskManager {
    # Task Manager
    $taskman = "$($env:windir)\system32\taskmgr.exe"
    & $taskman
}

function Invoke-ADUsersAndComputersManagement {
    # AD Users and computers
    $dsa = "$($env:windir)\system32\dsa.msc"
    & $dsa
}

function Invoke-ServicesManagement {
    # Services
    services.msc
}

function Invoke-GroupPolicyManagement {
    # Group Policy
    gpedit.msc
}

function Invoke-DeviceManagement {
    # Device management
    devmgmt.msc
}

function Invoke-WindowsUpdateManagement {
    # Windows Update
    & "$($env:windir)\system32\wuapp.exe" startmenu
}

function Invoke-DNSManagement {
    # DNS
    & "$env:SystemRoot\system32\mmc.exe" $env:SystemRoot\system32\dnsmgmt.msc /s
}

function Invoke-LocalUserManagement {
    # Local groups
    $lusr = "$($env:windir)\system32\lusrmgr.msc"
    & $lusr
}

function Invoke-LocalHostsManagement {
    # Local hosts
    notepad c:\windows\system32\drivers\etc\hosts
}
Set-Alias -Name Invoke-HostsManagement -Value Invoke-LocalHostsManagement

function Invoke-HyperVManagement {
    $mmc = "$($env:windir)\system32\mmc.exe"
    $hyperv = "$($env:windir)\System32\virtmgmt.msc"
    & $mmc $hyperv
}

function Invoke-InternetExplorer {
    & "C:\Program Files (x86)\Internet Explorer\iexplore.exe"
}

function Invoke-Chrome {
    & "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
}
