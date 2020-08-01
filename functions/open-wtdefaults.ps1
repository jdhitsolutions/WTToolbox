
Function Open-WTDefault {
    [CmdletBinding()]
    Param()

    Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($MyInvocation.MyCommand)"

    <#
    Need to account for preview and/or stable releases.
    Only run this command is a Windows Terminal session.
    #>

    Write-Verbose "[$((Get-Date).TimeofDay)] Getting process path"
    $wtProcess = Get-WTProcess | where-object {$_.name -eq 'WindowsTerminal'}
    $appPath = Split-Path -path $wtProcess.path

    if ($appPath) {
        Write-Verbose "[$((Get-Date).TimeofDay)] Using process path $appPath"
        $json = Join-Path -path $appPath -ChildPath defaults.json
        Write-Verbose "[$((Get-Date).TimeofDay)] Testing for $json"
        if (Test-Path $json) {
            Write-Verbose "[$((Get-Date).TimeofDay)] Opening $json"
            Invoke-Item $json
        }
        else {
            Write-Warning "Could not find $json."
        }
    }
    else {
        Throw "Windows Terminal is not installed or you are not running this session of PowerShell in it."
    }
    Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($MyInvocation.MyCommand)"
}