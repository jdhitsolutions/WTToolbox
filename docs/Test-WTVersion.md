---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version:
schema: 2.0.0
---

# Test-WTVersion

## SYNOPSIS

Test if newer version of Windows Terminal is installed.

## SYNTAX

```yaml
Test-WTVersion [<CommonParameters>]
```

## DESCRIPTION

Because Windows Terminal can update in the background, you may not be aware that you are running a newer version. A newer version might offer new features to enable in your settings file or things that you have to change. This command will compare the currently installed version with saved information from the last time the command was run. If the version is newer, this command returns True. The command writes a small json file to $Home.

## EXAMPLES

### Example 1

```powershell

PS C:\> Test-WTVersion
False
```

Windows Terminal has not changed since the last check.

### Example 2

```powershell
PS C:\> if ( $env:wt_session -AND Test-WTVersion) {
    Write-Host "A newer version of Windows Terminal is now installed." -foreground Yellow
    Start-Process https://github.com/microsoft/terminal/releases
}
```

Because Windows Terminal can silently update, it may be difficult to know if you are running a new version. You might use the `Test-WTVersion` command in your PowerShell profile script with this code snippet.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Boolean

## NOTES


Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
