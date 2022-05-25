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
            $get = Invoke-RestMethod -Uri $uri -Method Get -ErrorAction stop

            if ($Preview) {
                Write-Verbose "[$((Get-Date).TimeofDay)] Getting latest preview release"
                $data = $get | Where-Object { $_.prerelease -eq "true" } | Select-Object -First 1
            }
            else {
                Write-Verbose "[$((Get-Date).TimeofDay)] Getting latest stable release"
                $data = $get | Where-Object { $_.prerelease -ne "true" } | Select-Object -First 1
            }
            #download
            #Need to filter out the preinstallkie.zip (Issue #7)
            $msix = ($data.assets).where( { $_.name -match '\.msixbundle$' })
            #($data.assets.name).where({$_ -match '\.msixbundle$'})

            #Need to acocunt for Windows 10 or Windows 11 bundle - JDH 5/25/2022
            if ($msix.count -gt 1) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Found $($msix.count) possible packages"
                $os = (Get-CimInstance win32_operatingsystem).caption
                #Convert value like Windows 11 to Win_11 to match msix name
                $short = [system.text.RegularExpressions.Regex]::Match($os, "Windows\s+\d{2}").value -replace "Windows\s+", "Win"
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting matching package for $short"
                $msix = $msix | Where-Object { $_.name -match $short }
            }
            if ($msix.name.count -eq 1) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Downloading $($msix.name)"
                $src = $msix.browser_download_url
                $target = Join-Path -Path $env:temp -ChildPath $msix.name.trim()
                if ($pscmdlet.shouldProcess($src, "Download and install")) {
                    Invoke-WebRequest -Uri $src -OutFile $target -DisableKeepAlive -UseBasicParsing -ErrorAction Stop
                    Add-AppxPackage -Path $target -ErrorAction stop
                }
            }
            else {
                Write-Warning "Failed to find a single matching msix package to install for this operating system."
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