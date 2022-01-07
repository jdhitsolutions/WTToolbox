Function Set-WTDefaultProfile {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "The Windows Terminal profile guid including the {}."
            )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            Try {
                [void]([guid]::Parse($_))
                $True
            }
            Catch {
                Throw "The value cannot be parsed as a guid."
                $false
            }
        })]
        [string]$Guid
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        #get all defined GUIDs
        #I'll assume $wtsettings is current
        #$wtsettings.refresh()
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Building a profile guid list"
        $list = $WTSettings.profiles.list | Select-Object -property name,guid |
        Group-Object -property GUID -ashashtable -asString
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using guid $Guid"
        if ($list.keys -contains $Guid) {
            #define a regex to get the defaultprofile from the settings.json file
            $rx=[System.Text.RegularExpressions.Regex]::new("(?<=defaultProfile"":\s"")$($wtsettings.DefaultProfile)","MultiLine")
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using regex $($rx.toString())"
            #initialize a collection to hold the settings json file
            $file = [System.Collections.Generic.list[string]]::new()
            #get the content
            $settingsContent = Get-Content $WTSettingsPath
            #add the content to the collection
            $settingsContent | foreach-Object { $file.add($_)}
            $name = $list.$guid.name
            $i = $file.FindIndex({$args[0] -match $rx})
            $line = $file[$i]
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Replacing-> $($line.trim())"
            $file[$i] = $rx.replace($line,$guid)
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] .....with-> $($file[$i].trim())"
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Updating $WTSettingsPath"
            if ($PSCmdlet.ShouldProcess("$name $guid", "Set default Windows Terminal profile")) {
                $file | Out-File -FilePath $WTSettingsPath
            } #whatif
        }
        else {
            Write-Warning "Can't find a Windows Terminal profile with a guid of $Guid."
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Set-WTDefault