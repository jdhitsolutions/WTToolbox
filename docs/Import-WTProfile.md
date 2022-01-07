---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version:
schema: 2.0.0
---

# Import-WTProfile

## SYNOPSIS

Import a Windows Terminal profile.

## SYNTAX

```yaml
Import-WTProfile [-Path] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

If you exported Windows Terminal profiles to a Json file, you can use Import-WTProfile to add them to your settings file. You might do this when setting up a new desktop or restoring a backup. The imported profiles must have unique names. It is assumed the guids are unique and will not conflict with existing profile guids. All imported profiles will go to the top of your profile list.

## EXAMPLES

### Example 1

```powershell
PS C:\> Import-WTProfile c:\work\saved.json -Verbose
VERBOSE: [12:46:33.2526304 BEGIN  ] Starting Import-WTProfile
VERBOSE: [12:46:33.2588630 PROCESS] Importing Windows Terminal profiles from c:\work\saved.json
VERBOSE: [12:46:33.2603038 PROCESS] Found 3 profiles
VERBOSE: [12:46:33.2607900 PROCESS] Importing PS7.2 No Profile
WARNING: There is already a profile with the name of Windows PowerShell No Profile. Skipping import.
VERBOSE: [12:46:33.2612329 PROCESS] Importing WinCmd
VERBOSE: [12:46:33.2622307 END    ] Update settings.json
VERBOSE: [12:46:33.2763273 END    ] Ending Import-WTProfile
```

Import profiles from a Json file created with Export-WTProfile.

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

### -Path

Specify the path to a json file created with Export-WTProfile.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
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

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Export-WTProfile](Export-WTProfile.md)
