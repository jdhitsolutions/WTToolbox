# Change Log for WTToolBox

## 1.1.0

+ Added `Test-WTVersion`
+ Modified module to create a global variable `$WTSettings` with a converted version of `settings.json`.
+ Modified module to create a global variable `WTSettingsPath` with the path to the `setting.json` file.
+ Modified module to create a global variable `$WTDefaults` with a converted version of `defaults.json`.
+ Added a private function called `AddWTSettingsVariable    .
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
