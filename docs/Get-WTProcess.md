---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version: https://bit.ly/38JZf7d
schema: 2.0.0
---

# Get-WTProcess

## SYNOPSIS

Get Windows Terminal processes.

## SYNTAX

```yaml
Get-WTProcess [<CommonParameters>]
```

## DESCRIPTION

Use this command to get all processes that are part of the current Windows Terminal application. The command output is a regular System.Diagnostics.Process object. However, the default formatting will highlight the your PowerShell process in green text.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-WTProcess

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    913      48   110304      95016     458.05   7112   1 WindowsTerminal
    150      10     2264       7092       0.80   8600   1 OpenConsole
   2387     149   373980     351940      40.28  32548   1 pwsh
    150      11     2300       7272      54.94   9080   1 OpenConsole
   1912     106   517584     300388     124.61   3680   1 powershell
    150      10     2208       7748       0.13  14292   1 OpenConsole
    743      50   176648     124820       7.64  29668   1 powershell
    144      10     2228       8888       0.14  14132   1 OpenConsole
     67       5     4128       3632       0.02  31992   1 cmd
    148      11     2236       8900       0.16  26764   1 OpenConsole
    116       7     1248       5620       0.03  15308   1 wsl
```

The current PowerShell process will be formatted in color.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### WTProcess

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Process]()
