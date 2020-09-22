
Function Get-WTCurrentRelease {
    [cmdletbinding()]
    [OutputType("PSCustomObject")]
    Param(
        [Parameter(HelpMessage = "Get the latest preview release")]
        [switch]$Preview
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        $uri = "https://api.github.com/repos/microsoft/terminal/releases"
    } #begin
    Process {
        $get = Invoke-RestMethod -uri $uri -Method Get -ErrorAction stop
        if ($Preview) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting latest preview release"
            $data = $get | Where-Object {$_.prerelease -eq "true"} | Select-Object -first 1
            $local = GetWTPackage -preview
        }
        else {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting latest stable release"
            $data = $get | Where-Object {$_.prerelease -ne "true"} | Select-Object -first 1
            $local = GetWTPackage
        }

        if ($data.tag_name) {
            [pscustomobject]@{
                Name         = $data.name
                Version      = $data.tag_name
                Released     = $($data.published_at -as [datetime])
                LocalVersion = $local.version
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}