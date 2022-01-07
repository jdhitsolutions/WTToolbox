---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version:
schema: 2.0.0
---

# Get-WTProfile

## SYNOPSIS

Get a Windows Terminal profile

## SYNTAX

```yaml
Get-WTProfile [[-Name] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION

You can use this command to discover settings for your Windows Terminal profiles. The default behavior is to show all non-hidden profiles. But you can filter by name using wildcards. Or use -Force to include hidden profiles.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-WPprofile


   Name: PowerShell [{574e775e-4f2a-5b96-ac1e-a2962a402336}]

Title                          SourceCommand
-----                          -------------
                               Windows.Terminal.PowershellCore


   Name: PS7 No Profile [{c6783a98-47d9-4610-bc68-7a3f909e94fb}]

Title                          SourceCommand
-----                          -------------
PS7 NoProfile                  C:\Program Files\PowerShell\7\pwsh.exe -noprofile
...
```

The default output is formatted as a table. The default profile will be highlighted in green, or whatever is defined for green in your color scheme.

### Example 2

```powershell
PS C:\> Get-WTProfile -Force | Sort-Object Name


   Name: Azure Cloud Shell [{b453ae62-4e3d-5e58-b989-0a998ec441b8}]

Title                          SourceCommand
-----                          -------------
                               Windows.Terminal.Azure


   Name: Command Prompt [{0caa0dad-35be-5f56-a8ff-afceeeaa6101}]

Title                          SourceCommand
-----                          -------------
                               cmd.exe


   Name: DOM1 [{b89c512a-cd2b-4fb4-a6d2-3366cee85970}]

Title                          SourceCommand
-----                          -------------
PSRemote: DOM1.Company.Pri     powershell.exe -nologo -noprofile -noexit -file
                               c:\scripts\wtpsremote.ps1 -computername dom1
                               -credential company\artd -remoteprofile
                               c:\scripts\dom1-remoteprofile.ps1
...
```

Hidden profiles will have their name and guid displayed in red.

### Example 3

```powershell
PS C:\> Get-WTProfile ubuntu* | Select-Object *

Name              : Ubuntu
Guid              : {22010c0e-c464-49b2-97ef-fe764973cf54}
Hidden            : False
Title             : Ubuntu
SourceCommand     : wsl.exe -d Ubuntu-20.04
Icon              : C:\Users\Jeff\OneDrive\windowsterminal\ProfileIcons\ubuntu32x32.png
StartingDirectory : %USERPROFILE%
ColorScheme       : One Half Dark
UseAcrylic        :
AcrylicOpacity    :
```

The Get-WTProfile command only displays a subset of properties. But you can use an expression like:

  $wtsettings.profiles.list | Where name -match ubuntu

To view all properties. This expression uses the WTToolbox modules wtsettings variable. You need to import the module before you can use this variable.

## PARAMETERS

### -Force

Include hidden profiles.

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

### -Name

Enter a Windows Terminal profile name.
Wildcards are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: *
Accept pipeline input: False
Accept wildcard characters: True
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### wtProfile

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-WTCurrent](Get-WTCurrent.md)

[Set-WTDefaultProfile](Set-WTDefaultProfile.md)

[New-WTProfile](New-WTProfile.md)
