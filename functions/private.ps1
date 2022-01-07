
#a private helper function to parse the key settings into more manageable objects
#this is called in Get-WTKeyBinding

Function parsesetting {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [object]$Setting)

    Process {
        if ($setting.command -is [string]) {
            $cmd = $setting.command
            #assuming there is only a single key binding
            #it is also possible the json file may use array syntax
            #even though a single key combination is specified
            $keys = $setting.keys | Select-Object -First 1
            $actionsettings = $null
        }
        else {
            $cmd = $setting.command.action
            $keys = $Setting.keys | Select-Object -First 1
            #join other action settings into a string
            $other = $setting.command.psobject.properties.where( { $_.name -ne 'action' }) | ForEach-Object { "$($_.Name) = $($_.value)" }
            $actionsettings = $other -join ";"
        }
        [pscustomobject]@{
            Action         = $cmd
            ActionSettings = $actionsettings
            Keys           = $keys
        }
    }
}

Function AddWTSettingsVariable {
    [cmdletbinding()]
    Param()

    Write-Verbose "Parsing $global:WTSettingsPath"
    #need to strip out comments for Windows PowerShell
    #$pattern = "(?(?<=:|\/)no)(\/{2})(?=\s+)?"
    $pattern = "(\/{2})(?=\s+)?"
    Try {
        $obj = (Get-Content -Path $Global:WTSettingsPath).where({ $_ -notmatch $pattern -OR $_ -match "ms-appx:\/{3}" }) | ConvertFrom-Json -ErrorAction Stop
    }
    Catch {
        Write-Warning "Failed to parse settings.json. You might have an error in the file. $($_.Exception.Message)"
    }
    #only continue if there is an object
    if ($obj) {
        Write-Verbose "Adding custom properties"
        Add-Member -InputObject $obj -MemberType NoteProperty -Name Computername -Value $env:COMPUTERNAME
        Add-Member -InputObject $obj -MemberType NoteProperty -Name LastUpdated -Value ((Get-Item -Path $Global:WTSettingsPath).LastWriteTime)
        Add-Member -InputObject $obj -MemberType NoteProperty -Name LastRefresh -Value (Get-Date)

        Write-Verbose "Adding a method to refresh the object"
        Add-Member -InputObject $obj -MemberType ScriptMethod -Name Refresh -Value { AddWTSettingsVariable }
        Write-Verbose "Setting the WTSettings variable in the global scope"
        Set-Variable -Name WTSettings -Scope Global -Value $obj
    }
    else {
        Write-Warning "Failed to create the settings object."
    }
}

Function GetWTPackage {
    [cmdletbinding()]
    Param([switch]$Preview)

    if ($Preview) {
        $name = "Microsoft.WindowsTerminalPreview"
    }
    else {
        $name = "Microsoft.WindowsTerminal"
    }
    <#
    Sept. 22, 2020 JH
    PowerShell 7.1 is based on a newer version of .NET Core which breaks the AppX cmdlets. I'll use remoting to Windows PowerShell.
    #>
    <#
    Dec. 29, 2021 JH
     PowerShell 7.2 gets around the Appx bug by using implicit remoting to Windows PowerShell
     which is what I am doing here. Leaving this code as-is.
    #>
    if ($PSVersionTable.PSVersion.ToString() -match "^7\.[1-9]") {
        Write-Verbose "[$((Get-Date).TimeofDay)] Detected PowerShell $($matches[0])"
        Invoke-Command -ScriptBlock { Get-AppxPackage $using:Name } -ConfigurationName Microsoft.PowerShell -ComputerName localhost
    }
    else {
        Get-AppxPackage -Name $name
    }
}
Function NewWTProfile {
    [cmdletbinding()]
    Param([object]$WTProfile)

    #$WTProfile is an object from $wtsettings.profiles.list that will be converted
    #into a strongly typed object.
    if ($wtProfile.commandline) {
        $cmd = $wtProfile.commandline
    }
    else {
        $cmd = $wtProfile.source
    }
    if ($null -eq $wtprofile.hidden) {
        $hidden = $false
    }
    else {
        $hidden = $wtProfile.hidden
    }
    [pscustomobject]@{
        PSTypeName        = "wtProfile"
        Name              = $wtProfile.Name
        Guid              = $wtProfile.guid
        Hidden            = $Hidden
        Title          = $wtProfile.tabTitle
        SourceCommand     = $cmd
        Icon              = $WTProfile.Icon
        StartingDirectory = $WTProfile.StartingDirectory
        ColorScheme       = $WTProfile.ColorScheme
        UseAcrylic        = $WTProfile.UseAcrylic
        AcrylicOpacity    = $WTProfile.AcrylicOpacity
        CursorShape = $wtProfile.CursorShape
        IsDefault         = ($WTProfile.guid -eq $wtsettings.defaultProfile)
    }

}


Function Convert-HtmlToAnsi {
    [cmdletbinding()]
    [OutputType("string")]
    [alias("cha")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = "Specify an HTML color code like #13A10E"
        )]
        [ValidatePattern('^#\w{6}')]
        [string]$HTMLCode
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Converting $HTMLCode"
        $c = [System.Drawing.ColorTranslator]::FromHtml($htmlCode)
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] RGB = $($c.r),$($c.g),$($c.b)"
        $ansi = '[38;2;{0};{1};{2}m' -f $c.R,$c.G,$c.B
        $ansi
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end
} #close Convert-HTMLtoANSI

