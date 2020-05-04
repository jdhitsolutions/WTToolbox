---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version:
schema: 2.0.0
---

# Get-WTKeyBinding

## SYNOPSIS
Display Windows Terminal key binding information

## SYNTAX

```yaml
Get-WTKeyBinding [[-Format] <String>] [<CommonParameters>]
```

## DESCRIPTION

Get Windows Terminal key binding settings and display with your choice of formats.
If a keybinding from your settings.json file has the same keys as a default, the
default is overwritten in the output.

## EXAMPLES

### EXAMPLE 1

```powershell
c:\scripts\Get-WTKeyBindings -format grid
```

This is a PowerShell script so you need to specify the path to the file.

## PARAMETERS

### -Format

Specify how to display the results.
Possible values are:

   * Table
   * List
   * Grid
   * None

This parameter has an alias of 'out'.

```yaml
Type: String
Parameter Sets: (All)
Aliases: out

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None

### Custom Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
