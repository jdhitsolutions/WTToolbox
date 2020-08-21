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

acrylicOpacity             : 0.6
commandline                : C:\Program Files\PowerShell\7\pwsh.exe -nologo
guid                       : {993855ad-b0eb-4f3d-8370-1a8d5b53abb5}
icon                       : %USERPROFILE%\OneDrive\windowsterminal\ProfileIcons\pwsh.scale-150.png
name                       : PowerShell 7
tabTitle                   : PS 7
backgroundImage            : C:\Users\Jeff\OneDrive\terminalthumbs\Snover-head.png
backgroundImageAlignment   : bottomRight
backgroundImageStretchMode : none
backgroundImageOpacity     : 0.75
useAcrylic                 : True
```

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

This command has an alias of gwtc.

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
