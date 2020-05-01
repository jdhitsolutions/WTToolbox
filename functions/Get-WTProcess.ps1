
#get the Windows Terminal process and its children
Function Get-WTProcess {
    [cmdletbinding()]
    Param()

    $procs = @()
    $procs += Get-CimInstance -ClassName Win32_process -filter "Name='WindowsTerminal.exe'" -OutVariable wt
    $procs += Get-CimInstance win32_process -filter "ParentProcessID=$($wt[0].processID)"
    $procs | Sort-Object -Property CreationDate
}

<#
old code
this doesn't work in Windows PowerShell using Get-Process
Get-Process -name WindowsTerminal -OutVariable main
Write-Verbose "Getting processes related to $($main.id)"
(Get-Process).Where( {$_.parent.id -eq $main.id})
#>