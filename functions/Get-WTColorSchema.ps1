

Function Get-WTColorScheme {
    [cmdletbinding()]
    [OutputType("wtColorScheme")]
    Param(
        [Parameter(Position = 0, HelpMessage = "Specify a Windows Terminal color scheme name. Wildcards are allowed. The default is all schemes.")]
        [ValidateNotNullOrEmpty()]
        [string]$Name = "*"
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting color scheme $Name"
        $schemes = $wtsettings.schemes | Where-Object { $_.name -like $Name }
        if ($schemes) {
            foreach ($scheme in $schemes) {
                $props = $scheme.psobject.properties.where({ $_.name -ne 'name' })
                foreach ($item in $props) {
                    $ansi = (Convert-HtmltoAnsi $item.value)
                    [pscustomobject]@{
                        PSTypeName = "wtColorScheme"
                        Property    = $item.Name
                        SchemeValue = $item.Value
                        ANSIValue   = $ansi
                        Sample      = "$([char]27)$ansi$($item.name)$([char]27)[0m"
                        Name        = $scheme.name
                    }
                } #foreach item
            } #foreach scheme
        } #if
        else {
            Write-Warning "Could not find a matching color scheme."
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end

} #close Get-WTColorScheme