
#get the Windows Terminal process and its children
Function Get-WTProcess {
    [cmdletbinding()]
    [OutputType([System.Diagnostics.Process])]
    Param()

    Write-Verbose "Getting parent process ID for process $pid"
    $wt = Get-CimInstance -ClassName Win32_process -filter "ProcessID=$pid"

    if ($wt) {
        Write-Verbose "Getting child processes of ID $($wt.parentProcessID)"

        Get-CimInstance -classname Win32_Process -filter "ParentProcessID = $($wt.ParentProcessId)" -Property ProcessID |
        ForEach-Object -Begin { Get-Process -id $wt.ParentProcessId} -process  {Get-Process -id $_.processID} |
        Sort-Object StartTime
    }
    else {
        Write-Warning "This instance of PowerShell doesn't appear to be running in Windows Terminal."
    }
}
