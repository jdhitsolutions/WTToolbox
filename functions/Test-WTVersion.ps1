
Function Test-WTVersion {
    [CmdletBinding()]
    [OutputType([boolean])]
    Param()

    Write-Verbose "Starting $($myinvocation.MyCommand)"
    Write-Verbose "Get the currently installed application"
    $pkg = Get-AppxPackage -Name Microsoft.WindowsTerminal

    If ($pkg) {

        #get the version number
        [version]$current = $pkg.Version
        Write-Verbose "Found version $current"
        #check for previous version file
        $verFile = Join-Path -path $home -ChildPath wtver.json
        Write-Verbose "Testing for version tracking file $verFile"

        if (Test-Path -path $verfile) {
            Write-Verbose "Comparing versions"
            $in = Get-Content -Path $verFile | ConvertFrom-Json
            $previous = $in.VersionString -as [version]
            Write-Verbose "Comparing stored version $previous with current version $current"
            If ($current -gt $previous) {
                Write-Verbose "A newer version of Windows Terminal has been detected."
                $True
            }
            else {
                Write-Verbose "Windows Terminal is up to date."
                $False
            }
        }

        #create the json file, adding the version as a string which makes it easier to reconstruct
        Write-Verbose "Writing current information to $verFile."
        $current | Select-Object *,
        @{Name = "VersionString"; Expression = {$_.tostring()}},
        @{Name = "Date"; Expression = {(Get-Date).DateTime}} |
        ConvertTo-Json | Out-File -FilePath $verfile -Encoding ascii -Force
    } # if package found
    else {
        Throw "Windows Terminal is not installed."
    }
    Write-Verbose "Ending $($myinvocation.MyCommand)"
} #close function