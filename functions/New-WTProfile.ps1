Function New-WTProfile {
    [cmdletbinding(SupportsShouldProcess)]
    [outputtype("none")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specify the name of your new profile."
            )]
        [string]$Name,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specify the command-line to run"
            )]
        [string]$CommandLine,

        [Parameter(
            Mandatory, ValueFromPipelineByPropertyName,
            HelpMessage = "Specify the tab title"
            )]
        [alias("Title")]
        [string]$TabTitle,

        [Parameter(ValueFromPipelineByPropertyName,HelpMessage = "Specify a valid color scheme.")]
        [ArgumentCompleter({ $WTSettings.schemes.foreach({
                if ($_.name -match "\s") {
                    "'$($_.name)'"
                }
                else {
                    $_.name
                }
            }
          )}
        )]
        [ValidateNotNullOrEmpty()]
        [string]$ColorScheme = "Campbell",

        [Parameter(ValueFromPipelineByPropertyName,HelpMessage = "Specify a cursor shape.")]
        [ValidateSet( "bar",
            "doubleUnderscore",
            "emptyBox",
            "filledBox",
            "underscore",
            "vintage")]
        [string]$CursorShape = "bar",

        [Parameter(ValueFromPipelineByPropertyName,HelpMessage = "Do you want the profile to be marked as hidden?")]
        [switch]$Hidden,

        [Parameter(ValueFromPipelineByPropertyName,HelpMessage = "Specify a starting directory like %WINDIR% or C:\Work")]
        [string]$StartingDirectory = "%USERPROFILE%",

        [Parameter(ValueFromPipelineByPropertyName,HelpMessage = "Do you want to enable acrylic settings?")]
        [switch]$UseAcrylic,

        [Parameter(ValueFromPipelineByPropertyName,HelpMessage = "If you enable acrylic settings you can specify a value.")]
        [ValidateRange(0.1, 1)]
        [double]$AcrylicOpacity = "1.0",

        [Parameter(ValueFromPipelineByPropertyName,HelpMessage = "Specify the path to a background image.")]
        [ValidateScript({
            if ($_ -match "\w+") {
                $test = Test-Path $_
                if ($test) {
                    $True
                }
                else {
                    Throw "Can't find the image file $_"
                }
           }
           else {
               $True
           }
        })]
        [alias("bg")]
        [string]$BackgroundImage,

        [Parameter(ValueFromPipelineByPropertyName,HelpMessage = "Specify the background image opacity.")]
        [ValidateRange(0.1, 1)]
        [alias("bgopacity")]
        [double]$BackgroundImageOpacity = 1.0,

        [Parameter(ValueFromPipelineByPropertyName,HelpMessage = "Specify the background image stretch mode.")]
        [validateSet(
            "fill",
            "none",
            "uniform",
            "uniformToFill"
        )]
        [alias("bgstretch")]
        [string]$BackgroundImageStretchMode = "none",

        [Parameter(ValueFromPipelineByPropertyName,HelpMessage = "Specify the background image alignment.")]
        [ValidateSet(
            "bottom",
            "bottomLeft",
            "bottomRight",
            "center",
            "left",
            "right",
            "top",
            "topLeft",
            "topRight"
            )]
        [alias("bgalign")]
        [string]$BackgroundImageAlignment = "center"
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        #get existing names
        $current = $wtsettings.profiles.list.name
        #get current settings in a list
        $list = [System.Collections.Generic.list[string]]::new()
        Get-Content $wtsettingspath | foreach-object {
            $list.add($_)
        }
        #this list will hold the new profiles
        $add = [System.Collections.Generic.list[string]]::new()
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating Windows Terminal profile $Name "
        if ($current -contains $Name) {
            Write-Warning "There is already a profile with the name of $name."
            #bail out
            return
        }
        if ($BackgroundImage) {
            $BackgroundImage = Convert-Path $BackgroundImage
        }
        $new = [pscustomobject]@{
            commandline                = $CommandLine
            name                       = $Name
            guid                       = "{$((New-Guid).ToString())}"
            tabTitle                   = $TabTitle
            colorScheme                = $colorScheme
            hidden                     = $($Hidden -as [bool])
            startingDirectory          = $StartingDirectory
            useAcrylic                 = $($useAcrylic -as [bool])
            acrylicOpacity             = $acrylicOpacity
            cursorShape                = $cursorShape
            backgroundImage            = $BackgroundImage
            backgroundImageOpacity     = $BackgroundImageOpacity
            backgroundImageStretchMode = $BackgroundImageStretchMode
            backgroundImageAlignment = $backgroundImageAlignment
        }  | ConvertTo-Json

        if ($pscmdlet.ShouldProcess($name)) {
            $new.split("`r`n") | Foreach-Object {$add.add($_)}
            #add the closing comma
            $add[-1] = "$($new[-1]),"
            Write-Verbose ($add | Out-String)
        }
    } #process

    End {
        $i = $list.FindIndex({$args[0] -match '"list":'})
        #now find the opening [
        While ($list[$i] -notmatch "\[") {
            $i++
        }
        #insert the new profile(s) here
        $list.InsertRange($i+1,$add)
        #update the settings file
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Update settings.json"
        $list | Out-File -FilePath $WTsettingsPath
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close New-WTProfile