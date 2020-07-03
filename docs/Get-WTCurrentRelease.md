---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version:
schema: 2.0.0
---

# Get-WTCurrentRelease

## SYNOPSIS

Get the current Windows Terminal release

## SYNTAX

```yaml
Get-WTCurrentRelease [-Preview] [<CommonParameters>]
```

## DESCRIPTION

This command will give you a summary of the latest Windows Terminal release including locally installed versions. Use the -Preview parameter to check for the latest preview.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-WTCurrentRelease

Name                         Version     Released             LocalVersion
----                         -------     --------             ------------
Windows Terminal v1.0.1811.0 v1.0.1811.0 6/30/2020 6:59:57 PM 1.0.1811.0
```

## PARAMETERS

### -Preview

Get the latest preview release.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSCustomObject

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
