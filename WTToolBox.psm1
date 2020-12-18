
#region main code

#Turn on Verbose output if module was imported with -Verbose
if ($myinvocation.line -match "Verbose") {
    $VerbosePreference = "Continue"
}
if ($IsWindows -OR $PSEdition -eq 'Desktop') {

    Write-Verbose "Dot source the module script files"
    (Get-ChildItem $PSScriptRoot\functions\*.ps1).foreach( { .$_.fullname })

    Write-Verbose "Testing for Microsoft.WindowsTerminal"
    <#
    need to take into account that a user might have a preview version also installed
    of maybe they are only using the preview version.
    8/1/2020 jdh
    #>

    #use the settings of the currently running Windows Terminal

    <#
    Sept. 22, 2020 JH
    PowerShell 7.1 previews are based on a newer version of .NET Core which breaks the AppX cmdlets. I'll use remoting to Windows PowerShell.
    #>
    if ($PSVersionTable.PSVersion.ToString() -match "^7\.[1-9]") {
        Write-Verbose "PowerShell 7.x detected. Using implicit remoting to get the Appx package."
        $app = Invoke-Command -ScriptBlock { Get-AppxPackage Microsoft.WindowsTerminal* } -ConfigurationName Microsoft.PowerShell -ComputerName localhost
    }
    else {
        $app = Get-AppxPackage Microsoft.WindowsTerminal*
    }

    if ($app) {
        Write-Verbose "Windows Terminal is installed"
        Write-Verbose "Testing for a current WindowsTerminal Process"
        $wt = Get-CimInstance -ClassName Win32_process -Filter "ProcessID=$pid"
        #validate the parent process is Windows Terminal
        $parent = Get-Process -Id $wt.parentProcessID

        #modified to take into account PowerShell previews which launch from a cmd script 12/18/2020 jdh
        if ($parent.processname -match "WindowsTerminal" -OR $parent.parent.processname -match "WindowsTerminal") {
            Write-Verbose "Testing for settings.json"
            <#
            #build path from process path
            $wtPath = Split-Path -Path $parent.path
            #pull the release name from $wtpath -parsing out version number
            $release = Split-Path -path $wtpath -leaf
            #$trimmed = $Release -replace "_.*_", "_"
            #>

            #The application name should be static 12/18/2020 jdh
            $jsonPath = "$ENV:Userprofile\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
            Write-Verbose "Using path $jsonPath"
            If (Test-Path $jsonPath) {
                #Export settings path to a global variable
                Write-Verbose "Creating settings variable"
                $global:WTSettingsPath = $jsonPath

                #create a custom object with the settings.json values saved as $WTSettings
                AddWTSettingsVariable

                Write-Verbose "Creating a global variable with defaults"
                $defaults = Join-Path -Path $app.installLocation -ChildPath defaults.json
                $global:WTDefaultsPath = $defaults
                #need to account for preview and stable releases
                $global:WTDefaults = $defaults.foreach( {
                        $wtPath = $_
                        (Get-Content -Path $_).where( { $_ -notmatch "(\/{2})(?=\s+)" }) | ConvertFrom-Json |
                            Add-Member -MemberType NoteProperty -Name DefaultPath -Value $wtPath -PassThru
                    })
            } #if json file is found
            else {
                Write-Verbose "Failed to find $jsonPath"
            }
        } #if parent process is WT
        else {
            Write-Verbose "Failed to find WindowsTerminal as the parent process."
        }
    } #if $app
    else {
        Write-Warning "Windows Terminal was not found on this system so not all commands in this module will work."
    }

} #if Windows
else {
    Write-Warning "This module requires a Windows platform."
}
 #reset -Verbose if turned on
    if ($VerbosePreference -eq 'Continue') {
        Write-Verbose "Resetting verbose preference"
        $VerbosePreference = "SilentlyContinue"
    }
#endregion
