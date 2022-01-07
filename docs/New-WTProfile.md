---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version:
schema: 2.0.0
---

# New-WTProfile

## SYNOPSIS

Create a new Windows Terminal profile.

## SYNTAX

```yaml
New-WTProfile [-Name] <String> -CommandLine <String> -TabTitle <String> [-ColorScheme <String>] [-CursorShape <String>] [-Hidden] [-StartingDirectory <String>] [-UseAcrylic] [-AcrylicOpacity <Double>] [-BackgroundImage <String>] [-BackgroundImageOpacity <Double>] [-BackgroundImageStretchMode <String>] [-BackgroundImageAlignment <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

New-WTProfile makes it easier to create a custom Windows Terminal profile from a PowerShell prompt. Not every single setting is available, but enough to accomplish the bulk of the setting. Most of the parameters accept pipeline input so you can pipe an object with matching parameter names to New-WTProfile.

The new profile will be inserted at the top of the list in the settings.json file.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-WTProfile -Name CMD -CommandLine cmd.exe -TabTitle Windows -CursorShape vintage -StartingDirectory "%WINDIR%"
```

Create a new profile called CMD that will run cmd.exe starting in the Windows directory.

## PARAMETERS

### -AcrylicOpacity

If you enable acrylic settings you can specify a value.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1.0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BackgroundImage

Specify the path to a background image.

```yaml
Type: String
Parameter Sets: (All)
Aliases: bg

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BackgroundImageAlignment

Specify the background image alignment.

```yaml
Type: String
Parameter Sets: (All)
Aliases: bgalign
Accepted values: bottom, bottomLeft, bottomRight, center, left, right, top, topLeft, topRight

Required: False
Position: Named
Default value: center
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BackgroundImageOpacity

Specify the background image opacity.

```yaml
Type: Double
Parameter Sets: (All)
Aliases: bgopacity

Required: False
Position: Named
Default value: 1.0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BackgroundImageStretchMode

Specify the background image stretch mode.

```yaml
Type: String
Parameter Sets: (All)
Aliases: bgstretch
Accepted values: fill, none, uniform, uniformToFill

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ColorScheme

Specify a valid color scheme. You should be able to tab-complete through the list of defined schemes.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Campbell
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CommandLine

Specify the command-line to run

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

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

### -CursorShape

Specify a cursor shape.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: bar, doubleUnderscore, emptyBox, filledBox, underscore, vintage

Required: False
Position: Named
Default value: bar
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Hidden

Do you want the profile to be marked as hidden?

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name

Specify the name of your new profile.

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

### -StartingDirectory

Specify a starting directory like %WINDIR% or C:\Work

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: %USERPROFILE%
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TabTitle

Specify the tab title.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Title

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UseAcrylic

Do you want to enable acrylic settings?

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

### System.Management.Automation.SwitchParameter

### System.Double

## OUTPUTS

### none

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Set-WTDefaultProfile](Set-WTDefaultProfile.md)

[Get-WTProfile](Get-WTProfile.md)

[Import-WTProfile](Import-WTProfile.md)
