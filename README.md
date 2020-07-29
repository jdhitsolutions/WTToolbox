# WTToolBox

[![PSGallery Version](https://img.shields.io/powershellgallery/v/WTToolbox.png?style=for-the-badge&logo=powershell&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/WTToolBox/) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/WTToolBox.png?style=for-the-badge&label=Downloads)](https://www.powershellgallery.com/packages/WTToolBox/)

![WindowsTerminal](assets/wt-icon.png)

## Windows Terminal PowerShell Toolbox

A set of PowerShell functions for managing and working with the [Windows Terminal](https://www.microsoft.com/store/productId/9N0DX20HK701) application from Microsoft. You can download the module from the PowerShell Gallery. It should work on __Windows__ platforms under Windows PowerShell and PowerShell 7.

```powershell
Install-Module WTToolBox
```

Of course, it is assumed you have `Windows Terminal` installed or planned to. If `Windows Terminal` is not installed, you will get an warning message when you import this module.

## Module Commands

* [Backup-WTSetting](docs/Backup-WTSetting.md)
* [Get-WTKeyBinding](docs/Get-WTKeyBinding.md)
* [Get-WTReleaseNote](docs/Get-WTReleaseNote.md)
* [Get-WTProcess](docs/Get-WTProcess.md)
* [Get-WTCurrent](docs/Get-WTCurrent.md)
* [Open-WTDefault](docs/Open-WTDefault.md)
* [Test-WTVersion](docs/Test-WTVersion.md)
* [Get-WTCurrentRelease](docs/Get-WTCurrentRelease.md)
* [Install-WTRelease](docs/Install-WTRelease.md)

### Installing Windows Terminal

You can install the latest stable or preview release of Windows Terminal using the packages available on GitHub.

```powershell
Install-WTRelease [-preview]
```

### Displaying Key Bindings

Keeping track of all the possible keyboard shortcuts or keybindings can be difficult. `Get-WTKeyBinding` will go through all defined keybindings and display them. The command writes a custom object to the pipeline for each key binding. To simplify things, the command includes a formatting option so you can easily control how the settings are displayed.

![Get-WTKeyBinding](assets/get-wtkeybinding.png)

Or as a grid using `Out-GridView`.

![Get-WTKeyBinding](assets/wtkeybindings.png)

### Getting Current Settings

Use `Get-WTCurrent` to display the settings for the current PowerShell session in Windows Terminal.

![Get-WTCurrent](assets/wtcurrent.png)

### Tracking Windows Terminal Version

Because `Windows Terminal` can silently update, it may be difficult to know if you are running a new version. You might use the `Test-WTVersion` command in your PowerShell profile script like this:

```powershell
if ( $env:wt_session -AND Test-WTVersion) {
    Write-Host "A newer version of Windows Terminal is now installed." -foreground Yellow
    Start-Process https://github.com/microsoft/terminal/releases
}
```

On a related note, you can also use `Get-WTReleaseNote` which will get the latest release information from the `Windows Terminal` GitHub repository. If you are running PowerShell 7.x, you can pipe the command to `Show-Markdown`.

```powershell
Get-WTReleaseNote | Show-Markdown -UseBrowser
```

The document will have links to any referenced issues.

You can also use [Get-WTCurrentRelease](docs/Get-WTCurrentRelease.md) to get a quick peek at the latest online version and your locally installed version.

```powershell
PS C:\> Get-WTCurrentRelease


Name                         Version     Released             LocalVersion
----                         -------     --------             ------------
Windows Terminal v1.0.1811.0 v1.0.1811.0 6/30/2020 6:59:57 PM 1.0.1811.0
```

### Windows Terminal Processes

The `Get-WTProcess` command will get all processes associated with the current Windows Terminal process. The output is a normal `System.Diagnostics.Process` object, but the default formatting has been customized to highlight the current PowerShell process.

![Get-WTProcess](assets/wtprocess-ansi.png)

## Global Variables

To make it easier to see either default settings or your custom settings, when you import this module, it will define 3 global variables. Assuming, of course, that you have `Windows Terminal` installed and are using `settings.json`.

### WTSettingsPath

The path to `settings.json` is buried in your AppData folder. You can use `$WTSettingsPath` as a placeholder. Yes, you can easily open the file from `Windows Terminal`, but there may be other things you want to do with the path information.

### WTDefaults

You can use `$WTDefaults` as an object to view any number of default settings. Use `Open-WTDefaults` if you want to open the file in your code editor.

```powershell
PS C:>\ $WTDefaults | Select-Object -property initial*

initialCols initialRows
----------- -----------
        120          30
```

When you import the module, it will also create a variable called `WTDefaultsPath` which points to the `defaults.json` file. This makes it easier if you want to do something with the file like make a copy. If you want to view the file you can use the `Open-WTDefault` command.

### WTSettings

The last object is a customized version of the data in `settings.json`. The object should make it easier to see your settings.

```powershell
PS C:\> $wtsettings.profiles.list | where-object hidden

guid       : {b453ae62-4e3d-5e58-b989-0a998ec441b8}
hidden     : True
useAcrylic : False
name       : Azure Cloud Shell
source     : Windows.Terminal.Azure

guid   : {574e775e-4f2a-5b96-ac1e-a2962a402336}
hidden : True
name   : PowerShell
source : Windows.Terminal.PowershellCore

guid   : {6e9fa4d2-a4aa-562d-b1fa-0789dc1f83d7}
hidden : True
name   : Legacy
source : Windows.Terminal.Wsl

guid   : {c6eaf9f4-32a7-5fdc-b5cf-066e8a4b1e40}
hidden : True
name   : Ubuntu-18.04
source : Windows.Terminal.Wsl
```

The object includes a few additional properties.

![wtsettings](assets/wtsettings.png)

The `LastUpdated` value is when `settings.json` was last revised. The `LastRefresh` value indicates when this object was created. Because you might modify your settings, after importing this module, there needed to be a mechanism to refresh the data. The custom object has a `Refresh()` method you can run at any time.

```powershell
PS C:\> $WTSettings.refresh()
```

The method doesn't write anything to the pipeline.

> A quick note on the settings and defaults objects. The JSON standard does not recognize comments, yet they are used in `Windows Terminal` settings files. You can see them with leading // characters. In order to convert the JSON to objects, these comments must be stripped out of the content. This is done with a regular expression. PowerShell 7 is more forgiving if it detects comments. Windows PowerShell will refuse to convert the content from JSON. Although the module has been updated to better handle comments, tt is recommended that if you are using comments, that you insert a space after the leading slashes like this: `// this is a comment`.

## Future Versions

If you have any suggestions for enhancements or bug reports, please use the Issues section of this repository.

> *Last updated 2020-07-29 19:10:05Z UTC*
