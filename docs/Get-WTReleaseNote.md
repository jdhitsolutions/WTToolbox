---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version:
schema: 2.0.0
---

# Get-WTReleaseNote

## SYNOPSIS

Get the latest Windows Terminal release information from GitHub

## SYNTAX

```yaml
Get-WTReleaseNote [-AsMarkdown] [<CommonParameters>]
```

## DESCRIPTION

This command will query the Windows Terminal GitHub repository to get information about the latest release.

## EXAMPLES

### Example 1

```powershell
PS C:\> PS C:\> Get-WTReleaseNote

Name       : Windows Terminal Release Candidate v0.11.1251.0 (1.0rc1)
Version    : v0.11.1251.0
Published  : 5/5/2020 10:25:47 PM
Prerelease : False
Notes      : ## Changes

             This is the first release of Terminal whose name doesn't have "(Preview)" in it!
             That doesn't necessarily mean we're done, but it does mean that this is the first release candidate.

             ### Rendering (Performance!)

             * Terminal no longer renders the entire screen when something changes (#5345) (#5185) (#5092)
...
```

The default output is a custom object.

### Example 2

```powershell
PS C:\> Get-WTReleaseNote -AsMarkdown | Show-Markdown
```

In PowerShell 7 you can render the release note as a markdown document and display it as markdown in the console. Or use the -UseBrowser parameter with Show-Markdown to open the in a web browser. Referenced GitHub issues should have links to the original issue.

## PARAMETERS

### -AsMarkdown

Create a markdown document. Referenced GitHub issues should have links to the original issue.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: md

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
