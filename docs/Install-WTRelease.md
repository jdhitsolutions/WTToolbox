---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version: https://bit.ly/2O5k0kh
schema: 2.0.0
---

# Install-WTRelease

## SYNOPSIS

Install the latest Windows Terminal release

## SYNTAX

```yaml
Install-WTRelease [-Preview] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Normally, you can install Windows Terminal from the Microsoft Store. Or you can use this command to download and install the package from GitHub. Use this command when you want to install the latest preview.

## EXAMPLES

### Example 1

```powershell
PS C:\> Install-WTRelease
```

Install the latest Windows Terminal release. Add -Preview if you want the preview release.

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

### -Preview

Install the latest preview release package from Github.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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

### System.Management.Automation.SwitchParameter

## OUTPUTS

### none

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-WTCurrentRelease]()
