

Function Export-WTProfile {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "Specify a profile name. Wildards are permitted."
            )]
        [ValidateNotNullorEmpty()]
        [string]$Name = "*",
        [Parameter(HelpMessage = "Specify the json filepath.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if (Split-Path $_ -parent | Test-Path) {
                If ($_ -match "\.json$") {
                    $True
                }
                else {
                    Throw "$_ does not appear to be a json file."
                    $False
                }
            }
            else {
                Throw "Can't verify the location in $_."
                $false
            }
        })]
        [string]$Path = "$($env:computername)-wtprofile.json",

        [Parameter(HelpMessage = "Write the json file to the pipeline")]
        [switch]$Passthru
        )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        $wtsettings.refresh()
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Exporting Windows Terminal profile(s) to $Path"
        $profiles = ($wtsettings.profiles.list).where({$_.name -like $Name -AND $_.commandline})
        if ($profiles) {
            $profiles | ForEach-Object {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($_.name)"
            }
            $profiles | ConvertTo-Json | Out-File -FilePath $path
            if ($Passthru) {
                Get-Item -Path $path
            }
        }
        else {
            Write-Warning "No matching Windows Terminal profiles found."
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Export-WTProfile