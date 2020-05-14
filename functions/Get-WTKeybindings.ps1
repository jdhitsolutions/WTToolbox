Function Get-WTKeyBinding {

    [cmdletbinding()]
    Param(
        [Parameter(HelpMessage = "Specify how to display the results")]
        [ValidateSet("Table", "Grid", "List", "None")]
        [alias("out")]
        [string]$Format = "None"
    )

    Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($MyInvocation.MyCommand)"
    #use a list object to make it easier to remove duplicate keybindings
    $list = [System.Collections.Generic.List[Object]]::new()

    Write-Verbose "[$((Get-Date).TimeofDay)] Getting WindowsTerminal Appx package"
    $install =(Get-AppxPackage -name Microsoft.WindowsTerminal).InstallLocation
    Write-Verbose "[$((Get-Date).TimeofDay)] Getting defaults.json file"
    $defaults = Join-Path -path $install -ChildPath defaults.json

    Write-Verbose "[$((Get-Date).TimeofDay)] Getting default Windows Terminal settings from $defaults"
    #strip out the // comments since they aren't valid json
    $defaultsettings = Get-Content -path $defaults | Where-Object {$_ -notmatch "//"} | ConvertFrom-Json

    #get the keybindings and add a property that indicates where the setting came from.
    Write-Verbose "[$((Get-Date).TimeofDay)] Parsing default keybindings"
    $keys = $defaultsettings.keybindings |
    parsesetting |
    Select-Object -Property *, @{Name = "Source"; Expression = {"Defaults"}}

    Write-Verbose "[$((Get-Date).TimeofDay)] Found $($keys.count) default keybindings"
    #add the keybinding objects to the list
    $list.AddRange($keys)

    Write-Verbose "[$((Get-Date).TimeofDay)] Getting user settings"
    $settingsjson = "$ENV:Userprofile\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (Test-Path $settingsjson) {
        $settings = Get-Content -path $settingsjson | Where-Object {$_ -notmatch "//"} | ConvertFrom-Json

        #only process if there are keybindings
        if ($settings.keybindings) {
        $user = $settings.keybindings |
        parsesetting |
        Select-Object -Property *, @{Name = "Source"; Expression = {"Settings"}}
        Write-Verbose "[$((Get-Date).TimeofDay)] Found $($keys.count) user keybindings"

        #if there is a duplicate key binding, remove the default
        foreach ($item in $user) {
            $existing = $list.where( {$_.keys -eq $item.keys})
            if ($existing) {
                    Write-Verbose "[$((Get-Date).TimeofDay)] Detected an override of $($existing| Out-String)"
                [void]($list.Remove($existing))
            }
            #add the entry
            $list.Add($item)
        }
    } #if keybindings
    }

    Write-Verbose "[$((Get-Date).TimeofDay)] Formatting keybinding settings as $Format"
    Switch ($Format) {
        "Table" {
            $list | Sort-Object -Property Source, Keys |
            Format-Table -GroupBy Source -Property Action, ActionSettings, Keys -Wrap -AutoSize
        }
        "List" {
            $list | Sort-Object -Property Source, Keys |
            Format-List -GroupBy Source -Property Action, ActionSettings, Keys
        }
        "Grid" {
            $list | Out-GridView -title "Windows Terminal Key Bindings"
        }
        default {
            $list
        }
    }
    Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($MyInvocation.MyCommand)"
}