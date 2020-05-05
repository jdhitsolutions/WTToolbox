
#region main code

if ($IsWindows -OR $PSEdition -eq 'Desktop') {

    #dot source the script files
    (Get-ChildItem $PSScriptRoot\functions\*.ps1).foreach( {. $_.fullname})

    $app = Get-AppxPackage Microsoft.WindowsTerminal
    if ($app) {
        #Windows Terminal is installed
        if (Test-Path -Path "$ENV:Userprofile\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json") {
            $global:WTSettingsPath = "$ENV:Userprofile\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
            #Export settings path to a global variable
            #create a custom object with the settings.json values saved as $WTSettings
            AddWTSettingsVariable
        }
        #create a global variable with defaults
        $defaults = Join-Path -path $app.installlocation -ChildPath defaults.json
        $global:WTDefaults = (Get-Content -path $defaults).where( {$_ -notmatch "//"}) | ConvertFrom-Json
    }
    else {
        Write-Warning "Windows Terminal was not found on this system."
    }

}
else {
    Write-Warning "This module requires a Windows platform."
}

#endregion
