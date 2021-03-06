Function Install-WTRelease {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("none")]
    [Alias("Install-WindowsTerminal")]
    Param(
        [Parameter(ValueFromPipeline)]
        [switch]$Preview
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"

        $uri = "https://api.github.com/repos/microsoft/terminal/releases"

    } #begin

    Process {
        Try {
            Write-Verbose "[$((Get-Date).TimeofDay)] Getting information from $uri"
            $get = Invoke-RestMethod -uri $uri -Method Get -ErrorAction stop

            if ($Preview) {
                Write-Verbose "[$((Get-Date).TimeofDay)] Getting latest preview release"
                $data = $get | Where-Object {$_.prerelease -eq "true"} | Select-Object -first 1
            }
            else {
                Write-Verbose "[$((Get-Date).TimeofDay)] Getting latest stable release"
                $data = $get | Where-Object {$_.prerelease -ne "true"} | Select-Object -first 1
            }
            #download
            #Need to filter out the preinstallkie.zip (Issue #7)
            $msix = ($data.assets).where( {$_.name -match '\.msixbundle$'})
            #($data.assets.name).where({$_ -match '\.msixbundle$'})

            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Downloading $msix"
            $src = $msix.browser_download_url
            $target = Join-Path -Path $env:temp -ChildPath $msix.name.trim()
            if ($pscmdlet.shouldProcess($src, "Download and install")) {
                Invoke-WebRequest -uri $src -outfile $target -disableKeepAlive -useBasicParsing -erroraction Stop
                Add-AppxPackage -Path $target -ErrorAction stop
            }
        }
        Catch {
            Throw $_
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end

} #close Install-WTRelease