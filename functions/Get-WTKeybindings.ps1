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
    <#
    Need to get the correct application depending on whether running release or preview
    #>
    if ((Get-WTProcess | Where-Object {$_.name -eq 'WindowsTerminal'}).path -match 'preview') {
        $pkg = "Microsoft.WindowsTerminalPreview"
    }
    else {
        $pkg = "Microsoft.WindowsTerminal"
    }
    $install = (Get-AppxPackage -name $pkg).InstallLocation

    Write-Verbose "[$((Get-Date).TimeofDay)] Getting defaults.json file"
    $defaults = Join-Path -path $install -ChildPath defaults.json

    Write-Verbose "[$((Get-Date).TimeofDay)] Getting default Windows Terminal settings from $defaults"
    #strip out the // comments since they aren't valid json
    $defaultsettings = Get-Content -path $defaults | Where-Object {$_ -notmatch "//"} | ConvertFrom-Json

    #get the keybindings and add a property that indicates where the setting came from.
    Write-Verbose "[$((Get-Date).TimeofDay)] Parsing default keybindings"
    <#
    It looks like the json schema might be changing so I need to allow for name variations.
    8/1/2020 jdh
    #>
    $keys = $defaultsettings | Select-Object -Expandproperty "*bindings" |
    parsesetting |
    Select-Object -Property *, @{Name = "Source"; Expression = {"Defaults"}}

    Write-Verbose "[$((Get-Date).TimeofDay)] Found $($keys.count) default keybindings"
    #add the keybinding objects to the list
    $list.AddRange($keys)

    $settingsjson = $global:wtsettingspath
    Write-Verbose "[$((Get-Date).TimeofDay)] Getting user settings from $settingsjson"

    if (Test-Path -path $settingsjson) {
        Write-Verbose "[$((Get-Date).TimeofDay)] Converting content to json"
        $settings = Get-Content -path $settingsjson | Where-Object {$_ -notmatch "//"} | ConvertFrom-Json
        #this might change and be bindings or keybindings
        #only process if there are keybindings
        $bind = $settings | Select-Object -ExpandProperty "*bindings"
        if ($bind) {
            $user =$bind |
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