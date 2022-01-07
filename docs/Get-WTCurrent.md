---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version: https://bit.ly/3ec5a6e
schema: 2.0.0
---

# Get-WTCurrent

## SYNOPSIS

Get Windows Terminal profile settings for the current session.

## SYNTAX

```yaml
Get-WTCurrent [<CommonParameters>]
```

## DESCRIPTION

Use this command to display the Windows Terminal profile settings for the current PowerShell session. You cannot use this object to modify any settings. It is read-only.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-WTCurrent


   Name: Windows PowerShell No Profile [{ca3da2bd-de18-40f7-9fc6-234345d1e89f}]

Title                          SourceCommand
-----                          -------------
PS No Profile                  powershell.exe -nologo -noexit -noprofile -file
                               c:\scripts\miniprofile51.ps1
```

The output is custom object that may not reflect all of the defined setting. You can use use the $WTSettings variable to discover them with an expression like:

$WTSettings.profiles.list | Where {$_.guid -eq $wtsettings.defaultProfile}


## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### wtProfile

## NOTES

This command has an alias of gwtc.

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-WTProfile](Get-WTProfile.md)
