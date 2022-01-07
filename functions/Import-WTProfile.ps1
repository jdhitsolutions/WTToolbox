Function Import-WTProfile {
    [cmdletbinding(SupportsShouldProcess)]
    [outputtype("none")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Specify the path to a json file created with Export-WTProfile."
        )]
        [ValidateScript({
            #validate file exits
            if (Test-Path $_) {
                #now test for extension
                if ($_ -match "\.json$") {
                    $True
                }
                else {
                    Throw "The filename must end in '.json'."
                }
            }
            else {
                Throw "Cannot find file $_."
            }
        })]
        [string]$Path
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        #get existing names
        $current = $wtsettings.profiles.list.name
        #get current settings in a list
        $list = [System.Collections.Generic.list[string]]::new()
        Get-Content $wtsettingspath | ForEach-Object {
            $list.add($_)
        }
        #this list will hold the new profiles
        $add = [System.Collections.Generic.list[string]]::new()
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Importing Windows Terminal profiles from $path"
        Try {
            #convert to objects for validation. Objects that pass validation will
            #be converted back to json
            $import = Get-Content -Path $Path | ConvertFrom-Json -ErrorAction stop
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Found $($import.count) profiles"
        }
        Catch {
            Throw $_
            #make sure to bail out of the command
            return
        }

        foreach ($item in $import) {
            if ($current -contains $item.Name) {
                Write-Warning "There is already a profile with the name of $($item.name). Skipping import."
            }
            else {
                [string[]]$new = $item | ConvertTo-Json
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Importing $($item.name)"
                $add.AddRange($new)
                #append a comma
                $add[-1] += ","
            }
        } #foreach

    } #process

    End {
        if ($add.count -gt 0) {
            $i = $list.FindIndex({ $args[0] -match '"list":' })
            #now find the opening [
            While ($list[$i] -notmatch "\[") {
                $i++
            }
            #insert the new profile(s) here
            $list.InsertRange($i + 1, $add)
            #update the settings file
            Write-Verbose "[$((Get-Date).TimeofDay) END    ] Update settings.json"
            $list | Out-File -FilePath $WTsettingsPath
        }
        else {
            Write-Warning "Nothing found to import."
        }
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close New-WTProfile