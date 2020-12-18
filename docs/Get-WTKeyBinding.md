---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version: https://bit.ly/2Zcqg06
schema: 2.0.0
---

# Get-WTKeyBinding

## SYNOPSIS

Display Windows Terminal key binding information.

## SYNTAX

```yaml
Get-WTKeyBinding [-Action <String>] [<CommonParameters>]
```

## DESCRIPTION

Get Windows Terminal key binding settings. If a keybinding from your settings.json file has the same key combination as a default, the default setting is overwritten. Use the Action parameter to filter for specific types of actions.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\Get-WTKeyBinding
```

Get Windows Terminal key bindings and display in the default formatted table view.

### EXAMPLE 2

```powershell
PS C:\> Get-WTKeyBinding -Action *font* | Format-List


      Source: Defaults


Action         : adjustFontSize
ActionSettings : delta = 1
Keys           : ctrl+=

Action         : adjustFontSize
ActionSettings : delta = -1
Keys           : ctrl+-

Action         : resetFontSize
ActionSettings :
Keys           : ctrl+0
```

Display a specific action. Wildcards are permitted.

## PARAMETERS

### -Action

Select an action type. The command should autocomplete possible choices.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### wtKeybinding

## NOTES

This command has an alias of gwtk.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
