# Change Log for WTToolBox

## 1.7.0

+ Fixed bug in `Install-WTToolbox` that was breaking the installation.


## 1.6.0

+ Modified by `Get-WTCurrent` to work when settings file is based on defaults. (Issue #2)
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

+ Added `Test-WTVersion`
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
