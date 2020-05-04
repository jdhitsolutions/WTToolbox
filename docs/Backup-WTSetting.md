---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version:
schema: 2.0.0
---

# Backup-WTSetting

## SYNOPSIS

Backup Windows Terminal settings.json file.

## SYNTAX

```yaml
Backup-WTSetting [[-Limit] <Int32>] [-Destination] <String> [-Passthru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Use this command to create a backup copy of the settings.json file for Windows Terminal. Each backup will be numbered up to the the specified limit. The oldest file will be called settings.bak1.json with the number incrementing for each backup.

## EXAMPLES

### Example 1

```powershell
PS C:\> Backup-WTSetting -destination D:\OneDrive\Backups
```

Create backups to D:\OneDrive\Backups using the default limit.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Destination

Specify the backup location. It must exist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit

The number of backup files to keep.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: 7
Accept pipeline input: False
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
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru

Write backup file objects to the pipeline. Otherwise the command doesn't write anything to the pipeline.

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

### None

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
