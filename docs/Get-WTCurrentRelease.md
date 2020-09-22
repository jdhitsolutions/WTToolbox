---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version: https://bit.ly/2AKSPby
schema: 2.0.0
---

# Get-WTCurrentRelease

## SYNOPSIS

Get the current Windows Terminal release.

## SYNTAX

```yaml
Get-WTCurrentRelease [-Preview] [<CommonParameters>]
```

## DESCRIPTION

This command will give you a summary of the latest Windows Terminal release, including locally installed versions. Use the -Preview parameter to check for the latest preview.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-WTCurrentRelease

Name                         Version     Released             LocalVersion
----                         -------     --------             ------------
Windows Terminal v1.3.2651.0 v1.3.2651.0 9/22/2020 4:00:29 PM 1.2.2381.0
```

### Example 2

```powershell
PS C:\> Get-WTCurrentRelease -Preview

Name                                 Version     Released             LocalVersion
----                                 -------     --------             ------------
Windows Terminal Preview v1.4.2652.0 v1.4.2652.0 9/22/2020 4:00:31 PM 1.3.2382.0
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

[Test-WTVersion](Test-WTVersion.md)
