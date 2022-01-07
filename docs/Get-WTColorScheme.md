---
external help file: WTToolBox-help.xml
Module Name: WTToolBox
online version:
schema: 2.0.0
---

# Get-WTColorScheme

## SYNOPSIS

Get Windows Terminal color schemes

## SYNTAX

```yaml
Get-WTColorScheme [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION

Get-WTColorScheme will enumerate the defined Windows Terminal color schemes. You can specify a scheme by name. The default is to return all schemes. The formatted output includes a color sample so you can view the results in your terminal session. For example, different schemes may have different definitions for "red".

## EXAMPLES

### Example 1

```powershell
PS C:\> PS C:\> Get-WTColorScheme 'One Half Dark'

    Name: One Half Dark

Property            SchemeValue ANSIValue          Sample
--------            ----------- ---------          ------
background          #282C34     [38;2;40;44;52m    background
black               #282C34     [38;2;40;44;52m    black
blue                #61AFEF     [38;2;97;175;239m  blue
brightBlack         #5A6374     [38;2;90;99;116m   brightBlack
brightBlue          #61AFEF     [38;2;97;175;239m  brightBlue
brightCyan          #56B6C2     [38;2;86;182;194m  brightCyan
brightGreen         #98C379     [38;2;152;195;121m brightGreen
brightPurple        #C678DD     [38;2;198;120;221m brightPurple
brightRed           #E06C75     [38;2;224;108;117m brightRed
brightWhite         #FFFFFF     [38;2;255;255;255m brightWhite
brightYellow        #E5C07B     [38;2;229;192;123m brightYellow
cursorColor         #FFFFFF     [38;2;255;255;255m cursorColor
cyan                #56B6C2     [38;2;86;182;194m  cyan
foreground          #DCDFE4     [38;2;220;223;228m foreground
green               #98C379     [38;2;152;195;121m green
purple              #C678DD     [38;2;198;120;221m purple
red                 #E06C75     [38;2;224;108;117m red
selectionBackground #FFFFFF     [38;2;255;255;255m selectionBackground
white               #DCDFE4     [38;2;220;223;228m white
yellow              #E5C07B     [38;2;229;192;123m yellow
```

The Sample property will be displayed using the ANSI escape sequence defined in ANSIValue.

### Example 2

```powershell
PS C:\> Get-WTColorScheme *dark | where Property -match "red|green|yellow|white"

   Name: One Half Dark

Property     SchemeValue ANSIValue          Sample
--------     ----------- ---------          ------
brightGreen  #98C379     [38;2;152;195;121m brightGreen
brightRed    #E06C75     [38;2;224;108;117m brightRed
brightWhite  #FFFFFF     [38;2;255;255;255m brightWhite
brightYellow #E5C07B     [38;2;229;192;123m brightYellow
green        #98C379     [38;2;152;195;121m green
red          #E06C75     [38;2;224;108;117m red
white        #DCDFE4     [38;2;220;223;228m white
yellow       #E5C07B     [38;2;229;192;123m yellow

   Name: Solarized Dark

Property     SchemeValue ANSIValue          Sample
--------     ----------- ---------          ------
brightGreen  #586E75     [38;2;88;110;117m  brightGreen
brightRed    #CB4B16     [38;2;203;75;22m   brightRed
brightWhite  #FDF6E3     [38;2;253;246;227m brightWhite
brightYellow #657B83     [38;2;101;123;131m brightYellow
green        #859900     [38;2;133;153;0m   green
red          #DC322F     [38;2;220;50;47m   red
white        #EEE8D5     [38;2;238;232;213m white
yellow       #B58900     [38;2;181;137;0m   yellow
```

Compare properties across different color schemes.

## PARAMETERS

### -Name

Specify a Windows Terminal color scheme name.
Wildcards are allowed.
The default is all schemes.

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

### wtColorScheme

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
