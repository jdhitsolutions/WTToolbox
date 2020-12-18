Function Get-WTKeyBinding {
    [cmdletbinding()]
    [outputtype("wtKeybinding")]
    [alias("gwtk")]
    Param(
        [Parameter(HelpMessage = "Select an action type.")]
        [ArgumentCompleter({'adjustFontSize','closeOtherTabs','closePane','closeTabsAfter','closeWindow','commandPalette','copy','duplicateTab','find','moveFocus','newTab','nextTab','openNewTabDropdown','openSettings','openTabColorPicker','paste','prevTab','resetFontSize','resizePane','scrollDown','scrollDownPage','scrollUp','scrollUpPage','splitPane','switchToTab','toggleAlwaysOnTop','toggleFocusMode','toggleFullscreen','togglePaneZoom','toggleRetroEffect'})]
        [ValidateNotNullOrEmpty()]
        [string]$Action
    )

    Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($MyInvocation.MyCommand)"
    #use a list object to make it easier to remove duplicate keybindings
    $list = [System.Collections.Generic.List[PSObject]]::new()

    Write-Verbose "[$((Get-Date).TimeofDay)] Getting WindowsTerminal Appx package"
    <#
    Need to get the correct application depending on whether running release or preview
    #>
    if ((Get-WTProcess | Where-Object { $_.name -eq 'WindowsTerminal' }).path -match 'preview') {
        $install = (GetWTPackage -preview).installLocation
    }
    else {
        $install = (GetWTPackage).installLocation
    }

    Write-Verbose "[$((Get-Date).TimeofDay)] Getting defaults.json file"
    $defaults = Join-Path -Path $install -ChildPath defaults.json

    Write-Verbose "[$((Get-Date).TimeofDay)] Getting default Windows Terminal settings from $defaults"
    #strip out the // comments since they aren't valid json
    $defaultsettings = Get-Content -Path $defaults | Where-Object { $_ -notmatch "//" } | ConvertFrom-Json

    #get the keybindings and add a property that indicates where the setting came from.
    Write-Verbose "[$((Get-Date).TimeofDay)] Parsing default keybindings"
    <#
    It looks like the json schema might be changing so I need to allow for name variations.
    8/1/2020 jdh

    Default keybindings are now defined under "actions" 9/22/2020 jdh
    #>
    Write-Verbose "[$((Get-Date).TimeofDay)] Detected $($defaultsettings.actions.count) default keybindings"
    if ($Action) {
        Write-Verbose "[$((Get-Date).TimeofDay)] Filtering for action $Action"
        #$defaultsettings.actions | out-string | write-Verbose

        #Windows PowerShell needs some help in unrolling collections so I'll explicitly cast this to an array of objects. 12/17/2020 jdh
        [object[]]$actionData = $defaultsettings.actions | Where-Object { $_.command -like $Action -OR $_.command.action -like $action }
    }
    else {
        [object[]]$actionData = $defaultsettings.actions
    }
    Write-Verbose "[$((Get-Date).TimeofDay)] Parsing $($actionData.count) default items"

    [object[]]$keys = $actionData | parsesetting | Select-Object -Property *, @{Name = "Source"; Expression = { "Defaults" } }

    Write-Verbose "[$((Get-Date).TimeofDay)] Found $($keys.count) default keybindings"
    #add the keybinding objects to the list
    if ($keys.count -gt 0) {
        foreach ($k in $keys) {
            #adding individually to the list because of how $keys is getting generated, especially when filtering on an action
            #12/17/2020 jdh
            #insert a typename 12/18/2020 jdh
            #insert a typename
            $k.psobject.typenames.insert(0,"wtKeyBinding")
            $list.add($k)
        }
    }

    $settingsjson = $global:wtsettingspath
    Write-Verbose "[$((Get-Date).TimeofDay)] Getting user settings from $settingsjson"

    if (Test-Path -Path $settingsjson) {
        Write-Verbose "[$((Get-Date).TimeofDay)] Converting content to json"
        $settings = Get-Content -Path $settingsjson | Where-Object { $_ -notmatch "//" } | ConvertFrom-Json
        #this might change and be bindings or keybindings
        #only process if there are keybindings
        #based on new defaults it might also be "actions" 9/22/2020 jdh
        $bindProp = $settings.psobject.properties.name -match "(bindings)|(keybindings)|(actions)"
        $bind = $settings | Select-Object -ExpandProperty $bindProp[0]
        if ($bind) {
            if ($Action) {
                Write-Verbose "[$((Get-Date).TimeofDay)] Filtering for action $action"
                $bind = $bind | Where-Object { $_.command -like $Action -OR $_.command.action -like $Action }
            }

            $user = $bind |
                parsesetting |
                Select-Object -Property *, @{Name = "Source"; Expression = { "Settings" } }
            Write-Verbose "[$((Get-Date).TimeofDay)] Found $($keys.count) user keybindings"

            #if there is a duplicate key binding, remove the default
            foreach ($item in $user) {
                $existing = $list.where({ $_.keys -eq $item.keys })
                if ($existing) {
                    Write-Verbose "[$((Get-Date).TimeofDay)] Detected an override of $($existing| Out-String)"
                    [void]($list.Remove($existing))
                }
                #insert a typename
                $item.psobject.typenames.insert(0,"wtKeyBinding")
                #add the entry
                $list.Add($item)
            }
        } #if keybindings
    }

    if ($list.count -gt 0) {
        #write the keybinding objects to the pipeline
        #removed previous options to format results as part of the command. That was a poor Practice. 12/18/2020 jdh
        $list

    }
    else {
        Write-Warning "No matching key bindings found."
    }
    Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($MyInvocation.MyCommand)"
}