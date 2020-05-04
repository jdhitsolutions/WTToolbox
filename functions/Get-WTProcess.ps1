
#get the Windows Terminal process and its children
Function Get-WTProcess {
    [cmdletbinding()]
    [OutputType([System.Diagnostics.Process])]
    Param()

    $wt = Get-CimInstance -ClassName Win32_process -filter "ProcessID=$pid"
    if ($wt) {
        Get-CimInstance -classname Win32_Process -filter "ParentProcessID = $($wt.ParentProcessId)" -Property ProcessID |
        ForEach-Object -Begin { Get-Process -id $wt.ParentProcessId} -process { Get-Process -id $_.processiD} |
        Sort-Object StartTime
    }
    else {
        Write-Warning "This instance of PowerShell doesn't appear to be running in Windows Terminal."
    }
}
