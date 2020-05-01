# a simple script to open the defaults.json file for Windows Terminal using
# the assoociate application for json files
Function Open-WTDefault {
    [CmdletBinding()]
    Param()

    $json = Join-Path -path (Get-AppxPackage Microsoft.WindowsTerminal).InstallLocation -ChildPath defaults.json
    if (Test-Path $json) {
        Invoke-Item $json
    }
    else {
        Write-Warning "Could not find default.json file."
    }
}