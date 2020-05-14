
#region main code

#Turn on Verbose output if module was imported with -Verbose
if ($myinvocation.line -match "Verbose") {
    $VerbosePreference = "Continue"
}
if ($IsWindows -OR $PSEdition -eq 'Desktop') {

    Write-Verbose "Dot source the module script files"
    (Get-ChildItem $PSScriptRoot\functions\*.ps1).foreach( {.$_.fullname})

    Write-Verbose "Testing for Microsoft.WindowsTerminal"
    $app = Get-AppxPackage Microsoft.WindowsTerminal
    if ($app) {
            Write-Verbose "Windows Terminal is installed"
            Write-Verbose "Testing for settings.json"
        if (Test-Path -Path "$ENV:Userprofile\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json") {
            #Export settings path to a global variable
            Write-Verbose "Creating settings variable"
            $global:WTSettingsPath = "$ENV:Userprofile\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

            #create a custom object with the settings.json values saved as $WTSettings
            AddWTSettingsVariable
        }
        Write-Verbose "Creating a global variable with defaults"
        $defaults = Join-Path -path $app.installlocation -ChildPath defaults.json
        $global:WTDefaultsPath = $defaults
        $global:WTDefaults = (Get-Content -path $defaults).where({$_ -notmatch "(\/{2})(?=\s+)"}) | ConvertFrom-Json
    }
    else {
        Write-Warning "Windows Terminal was not found on this system."
    }
}
else {
    Write-Warning "This module requires a Windows platform."
}

#endregion
