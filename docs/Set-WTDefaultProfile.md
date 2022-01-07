---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version:
schema: 2.0.0
---

# Set-WTDefaultProfile

## SYNOPSIS

Set the default Windows Terminal profile

## SYNTAX

```yaml
Set-WTDefaultProfile [-Guid] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

This command will set the default Windows Terminal profile. It will update your settings.json file.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-WTProfile -name Powershell | Set-WTDefaultProfile
```

Set the default profile. The easiest approach is to use Get-WTProfile to select the profile you wish to use and pipe that to Set-WTDefaultProfile.md.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Guid

The Windows Terminal profile guid including the {}. The easiest approach is to use Get-WTProfile to select the profile you wish to use and pipe that to Set-WTDefaultProfile.md.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### none

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-WTProfile](Get-WTProfile.md)
