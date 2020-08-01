---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version: https://bit.ly/2Ck0MF6
schema: 2.0.0
---

# Get-WTReleaseNote

## SYNOPSIS

Get the latest Windows Terminal release information from GitHub.

## SYNTAX

```yaml
Get-WTReleaseNote [-AsMarkdown] [-Online] [-Preview] [<CommonParameters>]
```

## DESCRIPTION

This command will query the Windows Terminal GitHub repository to get information about the latest release. You can also open the release notes directly on Github using the -Online parameter. This parameter will take precedence.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-WTReleaseNote


Name       : Windows Terminal v1.0.1401.0
Version    : v1.0.1401.0
Published  : 5/19/2020 4:08:09 PM
Prerelease : False
Notes      : ## Changes

             * Windows Terminal now ships with [Cascadia Code 2005.15](https://github.com/microsoft/cascadia-code/releases/tag/v2005.15).
             * All emoji are now sized as recommended by Unicode 13.0. You _will_ see some emoji that are smaller than you want them to be. That's just a fact of life. (#5934)
             * Documentation for Windows Terminal has moved to [docs.microsoft.com](http://docs.microsoft.com/windows/terminal)!
                * Existing user documentation in this repository will be moving to a nice farm upstate in short order.

             It will not escape your notice that there are two packages in this release:
             * `WindowsTerminal` is the stable build of Terminal.
             * `WindowsTerminalPreview` is the preview version, which can be installed _side-by-side_ with the stable version.
```

### Example 2

```powershell
PS C:\> Get-WTReleaseNote -AsMarkdown -Preview | Show-Markdown
```

In PowerShell 7, you can render the release note as a markdown document and display it as markdown in the console. This example will show the release note for the most recent preview release. You might also use the -UseBrowser parameter with Show-Markdown to open the in a web browser. Referenced GitHub issues should have links to the original issue.

### Example 3

```powershell
PS C:\> Get-WTReleaseNote -online
```

Open the release notes page from GitHub in your default web browser.

## PARAMETERS

### -AsMarkdown

Create a markdown document. Referenced GitHub issues should have links to the original issue.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: md

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Online

Open the online release notes. This parameter will take precedence.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

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

### System.String

### WTReleaseNote

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Install-WTRelease](Install-WTRelease.md)
