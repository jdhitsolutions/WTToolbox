
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
            $keys = $setting.keys | Select-Object -first 1
            $actionsettings = $null
        }
        else {
            $cmd = $setting.command.action
            $keys = $Setting.keys | Select-Object -first 1
            #join other action settings into a string
            $other = $setting.command.psobject.properties.where( {$_.name -ne 'action'}) | ForEach-Object {"$($_.Name) = $($_.value)"}
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
    $pattern ="(\/{2})(?=\s+)?"
    Try {
        $obj = (Get-Content -path $Global:WTSettingsPath).where({$_ -notmatch $pattern -OR $_ -match "ms-appx:\/{3}"}) | ConvertFrom-Json -ErrorAction Stop
    }
        Catch {
            Write-Warning "Failed to parse settings.json. You might have an error in the file. $($_.Exception.Message)"
    }
    #only continue if there is an object
    if ($obj) {
        Write-Verbose "Adding custom properties"
        Add-Member -inputObject $obj -MemberType NoteProperty -Name Computername -Value $env:COMPUTERNAME
        Add-Member -inputObject $obj -MemberType NoteProperty -Name LastUpdated -Value ((Get-Item -path $Global:WTSettingsPath).LastWriteTime)
        Add-Member -inputObject $obj -MemberType NoteProperty -Name LastRefresh -Value (Get-Date)

        Write-Verbose "Adding a method to refresh the object"
        Add-Member -inputObject $obj -MemberType ScriptMethod -Name Refresh -Value { AddWTSettingsVariable  }
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
    if ($PSVersionTable.PSVersion.ToString() -match "^7\.[1-9]") {
        Write-Verbose "[$((Get-Date).TimeofDay)] Detected PowerShell $($matches[0])"
        Invoke-Command -ScriptBlock { Get-AppxPackage $using:Name } -ConfigurationName Microsoft.PowerShell -ComputerName localhost
    }
    else {
         Get-AppxPackage -Name $name
    }
}

