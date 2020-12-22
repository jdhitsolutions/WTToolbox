
#get the Windows Terminal process and its children
Function Get-WTProcess {
    [cmdletbinding()]
    [alias("gwtp")]
    [OutputType("WTProcess")]
    Param()

    Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($MyInvocation.MyCommand)"
    Write-Verbose "[$((Get-Date).TimeofDay)] Getting parent process ID for process $pid"
    $wt = Get-CimInstance -ClassName Win32_process -Filter "ProcessID=$pid"
    #validate the parent process is Windows Terminal
    $parent = Get-Process -Id $wt.parentProcessID
    if ($parent.processname -match "WindowsTerminal" ) {
        Write-Verbose "[$((Get-Date).TimeofDay)] Found parent process $($parent.processname) [$($parent.iD)]"
        #use existing $wt variable
        $Verified = $True
    }
    elseif ($parent.parent.processname -match "WindowsTerminal") {
        Write-Verbose "[$((Get-Date).TimeofDay)] Found parent-parent process $($parent.parent.processname) [$($parent.id)]"
        #if parent process is cmd, assume you are running PowerShell 7.x Preview
        if ($parent.ProcessName -eq 'cmd') {
            $PSPreview = $True
        }
        $parent = $parent.parent
        $Verified = $True
    }
    else {
        Write-Warning "This instance of PowerShell doesn't appear to be running in Windows Terminal."
    }

    If ($Verified) {
        Write-Verbose "[$((Get-Date).TimeofDay)] Getting child processes of ID $($parent.ID)"

        $procs = Get-CimInstance -ClassName Win32_Process -Filter "ParentProcessID = $($Parent.Id)" -Property ProcessID |
            ForEach-Object -Begin { Get-Process -Id $Parent.Id } -Process { Get-Process -Id $_.processID } -end {
                if ($PSPreview) {
                    Get-Process -id $pid
                }
            }

        Write-Verbose "[$((Get-Date).TimeofDay)] Found $($procs.count) processes"

        #insert a custom type name to be used with a custom formatting file
        $procs | ForEach-Object { $_.psobject.typenames.insert(0, "WTProcess") }
        #write the results to the pipeline sorted by the start time
        $procs | Sort-Object -Property StartTime
    } #if verified

    Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($MyInvocation.MyCommand)"
}
