---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version:
schema: 2.0.0
---

# Export-WTProfile

## SYNOPSIS

Export a Windows Terminal profile.

## SYNTAX

```yaml
Export-WTProfile [[-Name] <String>] [-Path <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Export-WTProfile makes it easier to backup your custom Windows Terminal profiles. The export is to a Json file which you can import using Import-WTProfile. The export process will only export profiles with a commandline setting. It will ignore profiles like Azure Cloud Shell that use a source.

## EXAMPLES

### Example 1

```powershell
PS C:\> Export-WTProfile -Path c:\work\all-wt-profiles.json -Passthru -Verbose
VERBOSE: [11:44:27.0121595 BEGIN  ] Starting Export-WTProfile
VERBOSE: Parsing C:\Users\Jeff\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
VERBOSE: Adding custom properties
VERBOSE: Adding a method to refresh the object
VERBOSE: Setting the WTSettings variable in the global scope
VERBOSE: [11:44:27.0195423 PROCESS] Exporting Windows Terminal profile(s) to c:\work\all-wt-profiles.json
VERBOSE: [11:44:27.0200009 PROCESS] PS7 No Profile
VERBOSE: [11:44:27.0203622 PROCESS] Windows PowerShell
VERBOSE: [11:44:27.0207093 PROCESS] Windows PowerShell No Profile
VERBOSE: [11:44:27.0210646 PROCESS] Command Prompt
VERBOSE: [11:44:27.0214242 PROCESS] DOM1
VERBOSE: [11:44:27.0217793 PROCESS] Ubuntu

        Directory: C:\work


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---          1/7/2022  11:44 AM           3535 all-wt-profiles.json
VERBOSE: [11:44:27.0274847 END    ] Ending Export-WTProfile
```

Export all custom profiles to a json file.

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

### -Name

Specify a profile name. Wildards are permitted. The named profile must have a commandline value.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Passthru

Write the json file to the pipeline

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

### -Path

Specify the json filepath. Default is a file in the current directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $($env:computername)-wtprofile.json
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

[Import-WTProfile](Import-WTProfile.md)

[Backup-WTSetting](Backup-WTSetting.md)
