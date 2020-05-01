
#region main code

if ($IsWindows -OR $PSEdition -eq 'Desktop') {

    #dot source the script files
    (Get-Childitem $PSScriptRoot\functions\*.ps1).foreach({. $_.fullname})

}
else {
    Write-Warning "This module requires a Windows platform."
}

#endregion


