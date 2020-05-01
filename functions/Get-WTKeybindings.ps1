Function Get-WTKeyBinding {

    <#
.Synopsis
Display Windows Terminal key binding information
.Description
Get Windows Terminal key binding settings and display with your choice of formats.
If a keybinding from your settings.json file has the same keys as a default, the
default is overwritten in the output.
.Parameter Format
Specify how to display the results. Possible values are:

   * Table
   * List
   * Grid
   * None

Specify None to get the custom object output. This parameter has an alias
of 'out'.
.Example
PS C:\>  c:\scripts\Get-WTKeyBindings -format grid

This is a PowerShell script so you need to specify the path to the file.
#>


    [cmdletbinding()]
    Param(
        [Parameter(HelpMessage = "Specify how to display the results")]
        [ValidateSet("Table", "Grid", "List", "None")]
        [alias("out")]
        [string]$Format = "Table"
    )

    #a private helper function to parse the key settings into more manageable objects
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

    #use a list object to make it easier to remove duplicate keybindings
    $list = [System.Collections.Generic.List[Object]]::new()

    Write-Verbose "Getting default Windows Terminal settings"
    $defaults = Join-Path -path (Get-AppxPackage Microsoft.WindowsTerminal).InstallLocation -ChildPath defaults.json

    #strip out the // comments since they aren't valid json
    $defaultsettings = Get-Content -path $defaults | Where-Object {$_ -notmatch "//"} | ConvertFrom-Json

    #get the keybindings and add a property that indicates where the setting came from.
    $keys = $defaultsettings.keybindings |
    parsesetting |
    Select-Object -Property *, @{Name = "Source"; Expression = {"Defaults"}}

    Write-Verbose "Found $($keys.count) default keybindings"
    #add the keybinding objects to the list
    $list.AddRange($keys)

    Write-Verbose "Getting user settings"
    $settingsjson = "$ENV:Userprofile\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (Test-Path $settingsjson) {
        $settings = Get-Content -path $settingsjson | Where-Object {$_ -notmatch "//"} | ConvertFrom-Json
        $user = $settings.keybindings |
        parsesetting |
        Select-Object -Property *, @{Name = "Source"; Expression = {"Settings"}}
        Write-Verbose "Found $($keys.count) user keybindings"

        #if there is a duplicate key binding, remove the default
        foreach ($item in $user) {
            $existing = $list.where( {$_.keys -eq $item.keys})
            if ($existing) {
                Write-Verbose "Detected an override of $($existing| Out-String)"
                [void]($list.Remove($existing))
            }
            #add the entry
            $list.Add($item)
        }
    }

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
}