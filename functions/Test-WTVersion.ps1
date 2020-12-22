
Function Test-WTVersion {
    [CmdletBinding()]
    [OutputType([boolean])]
    Param()

    Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($myinvocation.MyCommand)"
    Write-Verbose "[$((Get-Date).TimeofDay)] Get the currently installed application"
    #only check if not running the Preview build
    if (Test-IsWTPreview) {
        Write-Host "You are running the Windows Terminal Preview" -ForegroundColor Yellow
        $pkg = GetWTPackage -preview
    }
    else {
         $pkg = GetWTPackage
    }

    If ($pkg) {
        $pkg | Out-String | Write-Verbose
        #get the version number
        [version]$current = $pkg.Version
        Write-Verbose "[$((Get-Date).TimeofDay)] Found version $current"
        #check for previous version file
        $verFile = Join-Path -path $home -ChildPath wtver.json
        Write-Verbose "[$((Get-Date).TimeofDay)] Testing for version tracking file $verFile"

        if (Test-Path -path $verfile) {
            Write-Verbose "[$((Get-Date).TimeofDay)] Comparing versions"
            $in = Get-Content -Path $verFile | ConvertFrom-Json
            $previous = $in.VersionString -as [version]

            Write-Verbose "[$((Get-Date).TimeofDay)] Comparing stored version $previous with current version $current"
            If ($current -gt $previous) {
                Write-Verbose "[$((Get-Date).TimeofDay)] A newer version of Windows Terminal has been detected."
                $True
            }
            else {
                Write-Verbose "[$((Get-Date).TimeofDay)] Windows Terminal is up to date."
                $False
            }
        }

        #create the json file, adding the version as a string which makes it easier to reconstruct
        Write-Verbose "[$((Get-Date).TimeofDay)] Writing current information to $verFile."
        $current | Select-Object *,
        @{Name = "VersionString"; Expression = {$_.tostring()}},
        @{Name = "Date"; Expression = {(Get-Date).DateTime}} |
        ConvertTo-Json | Out-File -FilePath $verfile -Encoding ascii -Force
    } # if package found
    else {
        Throw "Windows Terminal is not installed."
    }
    Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($myinvocation.MyCommand)"
} #close function

Function Test-IsWTPreview {
    [cmdletbinding()]
    [outputtype([Boolean])]
    Param()

    Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($myinvocation.MyCommand)"
    Write-Verbose "[$((Get-Date).TimeofDay)] Getting process id $pid"
    #get current process
    $current = Get-CimInstance win32_process -Filter "processid=$pid"

    #get WindowsTerminal parent
    Write-Verbose "[$((Get-Date).TimeofDay)] Getting parent process id $($current.parentprocessid)"
    $parent = Get-CimInstance win32_process -Filter "processid=$($current.parentprocessid)"

    #test if path matches the preview executable
    Write-Verbose "[$((Get-Date).TimeofDay)] Testing path $($parent.ExecutablePath)"
    $parent.ExecutablePath -match "WindowsTerminalPreview"
    
    Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($myinvocation.MyCommand)"
}
