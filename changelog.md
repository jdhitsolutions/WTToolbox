# Change Log for WTToolBox

## v1.12.0

+ Updated `Get-WTProcess` to better handle PowerShell preview sessions. (Issue #11)
+ Updated `Get-WTKeybinding` to better handle errors when action type not found. (Issue #10)
+ Fixed issue when importing the module running the Preview version of Windows Terminal. (Issue #13)
+ Added private function `Test-IsWTPreview`.
+ Updated `Test-WTVersion` to better handle Windows Terminal Preview.

## v1.11.1

+ Updated module file to handle failures with the Appx commands in PowerShell 7.1 and later. This will rely on using a remote connection to the Windows PowerShell installation on the local host. If PowerShell remoting is not enabled, this may not work. (Issue #9)
+ Modified module file to use a static value for part of the JSON settings path.
+ Fixed bug in module file that was not resetting Verbose preference.
+ Updated private function `GetWTPackage` to better handle PowerShell 7.x releases and the Appx bug.

## v1.11.0

+ Fixed IconUri in the module manifest.
+ Modified `Get-WTKeyBinding` to let the user filter on an action.
+ Modified `Get-WTKeyBinding` to write a structured object with a typename of `wtKeybinding` to the pipeline. Removed the `Format` parameter. _This is a breaking change_.
+ Added a custom format file `wtKeybinding.format.ps1xml`.
+ Added an `about_WTToolBox` help topic.

## v1.10.1

+ Added better error handling when encountering bad JSON. (Issue #8)
+ Minor updates to `README.md`.

## 1.10.0

+ Added a private function called `GetWTPackage` to get the Windows Terminal Appx package. This command will fall back to PowerShell Remoting when running PowerShell 7.1.
+ Updated `Get-WTKeyBindings` to handle property name change to `Action` for default keybindings.
+ Fixed a bug in `Get-WTReleaseNote` to separate preview and stable releases.
+ Updated `README.md`.

## 1.9.1

+ Forgot to define the `gwtc` alias.
+ Added an alias `gwtk` for `Get-WTKeyBinding`.
+ Added an alias `bwt` for `Backup-WTSetting`.
+ Updated `README.md`.
+ Help updates.

## 1.9.0

+ Fixed bug that was causing `Install-WTRelease` to fail. (Issue #7)
+ Added an alias `Install-WindowsTerminal` for `Install-WTRelease`.
+ Added an alias `gwtp` for `Get-WTProcess`.
+ Added an alias `gwtc` for `Get-WTCurrent`.

## 1.8.0

+ Modified module commands to take the Preview version into account. It is possible someone will have the preview installed and not the stable release. (Issue #6)
+ Updated the `WTDefaults` global variable to include the path and to accommodate multiple installed releases.
+ Revised `Open-WTDefault` to only run in a Windows Terminal session and to better detect if running under preview or stable release.
+ Added a `-Preview` parameter to `Get-WTReleaseNote` to retrieve the release note from the latest preview.
+ Revised `Get-WTKeyBinding` to handle possible property name change of `keybindings` to `bindings`.
+ Help updates

## 1.7.0

+ Fixed bug in `Install-WTToolbox` that was breaking the installation.
+ Minor grammar corrections to the `README.md`.

## 1.6.0

+ Modified by `Get-WTCurrent` to work when the settings file is based on defaults. (Issue #2)
+ Modified the regex pattern used to filter out comments to not require a space after //.
+ Added online links to help documentation.
+ Fixed typo in `AddWTSettingsVariable` that was preventing LastUpdated and LastRefresh properties from being defined.
+ Fixed typo in `Backup-WTSetting` that was not sorting backup files properly.
+ Updated `README.md`

## 1.5.0

+ Added `Install-WTRelease` (Issue #4)
+ Added `Get-WTCurrentRelease` (Issue #3)
+ Updated warning on module import.
+ Updated `README.md`
+ Help updates

## 1.4.0

+ Modified `Get-WTReleaseNote` to release objects, not pre-release.
+ Update `Get-WTReleaseNote` to include an `-Online` parameter to open the release notes in GitHub.
+ Updated Pester tests.

## 1.3.0

+ Modified code that generates `$WTSettings` and `WTDefaults` to not strip out icons and other content with // in the path.
+ Added `$WTDefaultsPath` variable.
+ Modified `Get-WTProcess` to write a custom object type to the pipeline.
+ Added `wtprocess.format.ps1xml` to format the current process process in green.
+ Added `Get-WTCurrent` command to display profile settings for the current PowerShell window.
+ Standardized verbose messages.
+ Updated `README.md`.

## 1.2.0

+ Added 'Get-WTReleaseNote`
+ Updated Pester test
+ Modified private function `AddWTSettingsVariable` to solve `Add-Member` problem. (Issue #1)
+ Modified `WTToolbox.psm1` to add Verbose support

## 1.1.0

+ Added `Test-WTVersion`.
+ Modified module to create a global variable `$WTSettings` with a converted version of `settings.json`.
+ Modified module to create a global variable `WTSettingsPath` with the path to the `setting.json` file.
+ Modified module to create a global variable `$WTDefaults` with a converted version of `defaults.json`.
+ Added a private function called `AddWTSettingsVariable.
+ Updated `README.md`.
+ Minor help revisions
+ Updated Pester test file

## 1.0.0

+ Updated module manifest
+ Published to the PowerShell Gallery
+ Added placeholder `readme.txt` files in unused folders
+ Refactored commands for better Pester testing
+ Added Pester tests for the module and commands

## 0.2.0

+ Updated `Get-WTProcess` to work in both Windows PowerShell and PowerShell 7
+ Updated `Get-WTProcess` to display results sorted by CreationDate
+ Added help documentation

## 0.1.0

+ initial files
