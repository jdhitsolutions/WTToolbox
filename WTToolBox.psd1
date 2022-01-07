#
# Module manifest for module WTToolBox
#

@{

    RootModule           = 'WTToolBox.psm1'
    ModuleVersion        = '1.14.0'
    CompatiblePSEditions = @('Desktop', 'Core')
    GUID                 = 'd7249a30-1995-47f7-9882-f3b6f246a14b'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2020-2022 Jeff Hicks. All rights reserved.'
    Description          = 'A set of PowerShell functions for managing and working with the Windows Terminal application from Microsoft.'
    PowerShellVersion    = '5.1'
    #PowerShellHostName = 'ConsoleHost'
    # TypesToProcess = @()
    FormatsToProcess     = @(
        "formats\wtprocess.format.ps1xml",
        "formats\wtKeybinding.format.ps1xml",
        "formats\wtprofile.format.ps1xml",
        "formats\wtcolorscheme.format.ps1xml"
    )
    FunctionsToExport    = 'Backup-WTSetting', 'Get-WTKeyBinding', 'Get-WTProcess',
    'Open-WTDefault', 'Test-WTVersion', 'Get-WTReleaseNote', 'Get-WTCurrent',
    'Get-WTCurrentRelease', 'Install-WTRelease', 'Test-IsWTPreview',
    'Get-WTProfile','Set-WTDefaultProfile','Get-WTColorScheme',
    'New-WTProfile','Export-WTProfile','Import-WTProfile'
    #VariablesToExport    = ''
    aliasesToExport      = 'Install-WindowsTerminal', 'gwtp', 'gwtc', 'gwtk', 'bwt'
    PrivateData          = @{

        PSData = @{
            Tags       = @('WindowsTerminal', 'wt', 'terminal')
            LicenseUri = 'https://github.com/jdhitsolutions/WTToolbox/blob/master/license.txt'
            ProjectUri = 'https://github.com/jdhitsolutions/WTToolbox'
            IconUri    = 'https://raw.githubusercontent.com/jdhitsolutions/WTToolbox/master/assets/wt-transparent.png'
        } # End of PSData hashtable

    } # End of PrivateData hashtable

}

