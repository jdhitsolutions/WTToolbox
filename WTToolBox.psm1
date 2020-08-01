
#region main code

#Turn on Verbose output if module was imported with -Verbose
if ($myinvocation.line -match "Verbose") {
    $VerbosePreference = "Continue"
}
if ($IsWindows -OR $PSEdition -eq 'Desktop') {

    Write-Verbose "Dot source the module script files"
    (Get-ChildItem $PSScriptRoot\functions\*.ps1).foreach( {.$_.fullname})

    Write-Verbose "Testing for Microsoft.WindowsTerminal"
    <#
    need to take into account that a user might have a preview version also installed
    of maybe they are only using the preview version.
    8/1/2020 jdh
    #>

    #use the settings of the currently running Windows Terminal
    $app = Get-AppxPackage Microsoft.WindowsTerminal*

    if ($app) {
        Write-Verbose "Windows Terminal is installed"
        Write-Verbose "Testing for a current WindowsTerminal Process"
        $wt = Get-CimInstance -ClassName Win32_process -filter "ProcessID=$pid"
        #validate the parent process is Windows Terminal
        $parent = Get-Process -id $wt.parentProcessID

        if ($parent.processname -match "WindowsTerminal") {
            Write-Verbose "Testing for settings.json"
            #build path from process path
            $wtPath = Split-Path -Path $parent.path
            #pull the release name from $wtpath -parsing out version number
            $release = Split-Path -path $wtpath -leaf
            $trimmed = $Release -replace "_.*_", "_"
            $local = Join-Path -path $ENV:Userprofile\AppData\Local\Packages -childpath $trimmed
            $jsonPath = Join-Path -path $local -ChildPath "LocalState\settings.json"
            Write-Verbose "Using path $jsonPath"
            If (Test-Path $jsonPath) {
                #Export settings path to a global variable
                Write-Verbose "Creating settings variable"
                $global:WTSettingsPath = $jsonPath

                #create a custom object with the settings.json values saved as $WTSettings
                AddWTSettingsVariable

                Write-Verbose "Creating a global variable with defaults"
                $defaults = Join-Path -path $app.installLocation -ChildPath defaults.json
                $global:WTDefaultsPath = $defaults
                #need to account for preview and stable releases
                $global:WTDefaults = $defaults.foreach( {
                        $wtPath = $_
                        (Get-Content -path $_).where( {$_ -notmatch "(\/{2})(?=\s+)"}) | ConvertFrom-Json |
                        Add-Member -memberType NoteProperty -name DefaultPath -value $wtPath -PassThru
                    })
            } #if json file is found
        } #if parent process is WT
    } #if $app
    else {
        Write-Warning "Windows Terminal was not found on this system so not all commands in this module will work."
    }
} #if Windows
else {
    Write-Warning "This module requires a Windows platform."
}

#endregion
