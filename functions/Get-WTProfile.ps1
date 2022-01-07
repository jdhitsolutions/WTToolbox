Function Get-WTProfile {
    [cmdletbinding()]
    [outputType("wtProfile")]
    Param(
        [Parameter(Position = 0, HelpMessage = "Enter a Windows Terminal profile name. Wildcards are permitted.")]
        [ValidateNotNullOrEmpty()]
        [string]$Name = "*",
        [Parameter(HelpMessage = "Include hidden profiles.")]
        [switch]$Force
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        if ($env:WT_PROFILE_ID) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting profile settings for $($env:WT_PROFILE_ID)"

            #refresh the settings object to get current values
            $wtsettings.refresh()
            $wtprofiles = $wtsettings.profiles.list
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Found a total of $($wtprofiles.count) profiles"
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting Windows Terminal profile $Name"
            $wtprofiles = $wtprofiles.where({$_.name -like "$Name"})
            if (-Not $Force) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Filtering out hidden profiles"
                $wtProfiles = $wtprofiles.where({-Not $_.hidden})
            }
            foreach ($wtProfile in $wtprofiles) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($wtprofile.name)"
                NewWTprofile $wtProfile
            } #foreach $wtProfile
        }
        else {
            Write-Warning "Failed to find a Windows Terminal profiles. Are you running this command in Windows Terminal"
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Get-WTProfile
