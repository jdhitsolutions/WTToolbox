# a simple script to open the defaults.json file for Windows Terminal using
# the assoociate application for json files
Function Open-WTDefault {
    [CmdletBinding()]
    Param()

    Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($MyInvocation.MyCommand)"
    Write-Verbose "[$((Get-Date).TimeofDay)] Getting AppxPackage for Microsoft.WindowsTerminal"
    $app = Get-AppxPackage Microsoft.WindowsTerminal

    if (Test-Path $app.InstallLocation) {
        $json = Join-Path -path $app.installlocation -ChildPath defaults.json
        if (Test-Path $json) {
            Write-Verbose "[$((Get-Date).TimeofDay)] Opening $json"
            Invoke-Item $json
        }
        else {
            Write-Warning "Could not find default.json file."
        }
    }
    else {
        Throw "Windows Terminal is not installed."
    }

    Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($MyInvocation.MyCommand)"
}