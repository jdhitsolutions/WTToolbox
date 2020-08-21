Function Get-WTCurrent {
    [cmdletbinding()]
    [alias('gwtc')]
    Param ()
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        if ($env:WT_PROFILE_ID) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting current profile settings for $($env:WT_PROFILE_ID)"

            #refresh the settings object to get current values
            $wtsettings.refresh()

            #Test if user is using the newer List entry in the json file
            #or is using a settings file based on defaults.json
            if ($wtsettings.profiles.list.guid) {
                $profile = $wtsettings.profiles.list.where({$_.guid -eq $env:WT_PROFILE_ID})
            }
            elseif ($wtsettings.profiles.guid) {
                $profile = $wtsettings.profiles.where( {$_.guid -eq $env:WT_PROFILE_ID})
            }
            if ($profile) {
                $profile
            }
            else {
                write-Warning "Failed to find a profile with a GUID matching $env:WT_PROFILE_ID"
            }
        }
        Else {
            Write-Warning "This session does not appear to be running under Windows Terminal"
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Get-WTCurrent