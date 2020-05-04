# a simple script to open the defaults.json file for Windows Terminal using
# the assoociate application for json files
Function Open-WTDefault {
    [CmdletBinding()]
    Param()

    $app = Get-AppxPackage Microsoft.WindowsTerminal

    if (Test-Path $app.InstallLocation) {
        $json = Join-Path -path $app.installlocation -ChildPath defaults.json
        if (Test-Path $json) {
            Invoke-Item $json
        }
        else {
            Write-Warning "Could not find default.json file."
        }
    }
    else {
        Throw "WindowsTerminal is not installed"
    }
}