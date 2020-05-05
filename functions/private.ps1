
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

    $obj = (Get-Content -path $Global:WTSettingsPath).where({$_ -notmatch "//"}) | ConvertFrom-Json
    #add a few custom properties
    $obj | Add-Member -MemberType NoteProperty -Name Computername -Value $env:COMPUTERNAME
    $obj | Add-Member -MemberType NoteProperty -Name LastUpdated -Value ((Get-Item -path $Global:WTSettingsPath).LastWriteTime)
    $obj | Add-Member -MemberType NoteProperty -Name LastRefresh -Value (Get-Date)
    #add a method to refresh the value
    $obj | Add-Member -MemberType ScriptMethod -Name Refresh -Value { AddWTSettingsVariable  }
    Set-Variable -Name WTSettings -Scope Global -Value $obj

}