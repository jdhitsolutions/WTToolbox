
#create backup copies of the Windows Terminal settings.json file

Function Backup-WTSetting {

    [CmdletBinding(SupportsShouldProcess)]
    Param(
        #how many backup copies should be saved
        [int]$Limit = 7,
        #backup folder
        [parameter(Mandatory, HelpMessage = "Specify the backup location")]
        [ValidateScript( {Test-Path $_})]
        [string]$Destination
    )

    $json = "$ENV:Userprofile\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

    Write-Verbose "Backing up $json to $Destination"
    Write-Verbose "Get existing backups and save as an array sorted by name"

    [array]$bak = Get-ChildItem -path $Destination -Name settings.bak*.json | Sort-Object -Property name

    if ($bak.count -eq 0) {
        Write-Verbose "Creating first backup copy."
        [int]$new = 1
    }
    else {
        #get the numeric value
        [int]$counter = ([regex]"\d+").match($bak[-1]).value
        Write-Verbose "Last backup is #$counter"

        [int]$new = $counter + 1
        Write-Verbose "Creating backup copy $new"
    }

    $backup = Join-Path -path $Destination -ChildPath "settings.bak$new.json"
    Write-Verbose "Creating backup $backup"
    Copy-Item -Path $json -Destination $backup

    #update the list of backups sorted by age and delete extras
    Write-Verbose "Removing any extra backup files over the limit of $Limit"

    Get-ChildItem -path $Destination\settings.bak*.json |
    Sort-Object -Property LastWriteTime -Descending |
    Select-Object -Skip $Limit | Remove-Item

    #renumber backup files
    Write-Verbose "Renumbering backup files"
    <#
You can't rename a file if it will conflict with an existing file so files will be copied
to a temp folder with a new name, the old file deleted and then the copy restored
#>
    Get-ChildItem -path $Destination\settings.bak*.json |
    Sort-Object -Property LastWriteTime |
    ForEach-Object -Begin {$n = 0} -process {
        #rename each file with a new number
        $n++
        $temp = Join-Path -path $env:TEMP -ChildPath "settings.bak$n.json"

        Write-Verbose "Copying temp file to $temp"
        $_ | Copy-Item -Destination $temp

        Write-Verbose "Removing $($_.name)"
        $_ | Remove-Item

    } -end {
        Write-Verbose "Restoring temp files to $Destination"
        Get-ChildItem -Path "$env:TEMP\settings.bak*.json" | Move-Item -Destination $Destination
    }

    #show current backup files
    Get-ChildItem -path $Destination\settings.bak*.json | Sort-Object -Property LastWriteTime -Descending
}