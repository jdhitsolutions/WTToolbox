
#get the Windows Terminal process and its children
Function Get-WTProcess {
    [cmdletbinding()]
    [OutputType("WTProcess")]
    Param()

    Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($MyInvocation.MyCommand)"
    Write-Verbose "[$((Get-Date).TimeofDay)] Getting parent process ID for process $pid"
    $wt = Get-CimInstance -ClassName Win32_process -filter "ProcessID=$pid"

    if ($wt) {
        Write-Verbose "[$((Get-Date).TimeofDay)] Getting child processes of ID $($wt.parentProcessID)"

        $procs = Get-CimInstance -classname Win32_Process -filter "ParentProcessID = $($wt.ParentProcessId)" -Property ProcessID |
        ForEach-Object -Begin { Get-Process -id $wt.ParentProcessId} -process  {Get-Process -id $_.processID}

        Write-Verbose "[$((Get-Date).TimeofDay)] Found $($procs.count) processes"
        #insert a custom type name to be used with a custom formatting file
        $procs | ForEach-Object {$_.psobject.typenames.insert(0,"WTProcess")}
        #write the results to the pipeline sorted by the start time
        $procs | Sort-Object -property StartTime
    }
    else {
        Write-Warning "This instance of PowerShell doesn't appear to be running in Windows Terminal."
    }
        Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($MyInvocation.MyCommand)"
}
