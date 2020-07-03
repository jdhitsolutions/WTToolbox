Function Get-WTReleaseNote {
    [CmdletBinding()]
    [outputtype([System.String])]
    [outputtype("WTReleaseNote")]
    Param(
        [Parameter(HelpMessage = "Create a markdown document")]
        [alias("md")]
        [switch]$AsMarkdown,
        [switch]$Online
    )

    Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($myinvocation.mycommand)"

    $uri = "https://api.github.com/repos/microsoft/terminal/releases"

    Try {
        Write-Verbose "[$((Get-Date).TimeofDay)] Getting information from $uri"
        $get = Invoke-Restmethod -uri $uri -Method Get -ErrorAction stop

        Write-Verbose "[$((Get-Date).TimeofDay)] Getting release information"
        $data = $get | Where-Object {$_.prerelease -ne "true"} | Select-Object -first 1

        $data | Select-Object -Property Name,tag_name,published_at,prerelease,

        @{Name="bodyLength";Expression = {$_.body.length}} | Out-String | Write-Verbose

        if ($online) {
            Write-Verbose "[$((Get-Date).TimeofDay)] Opening $($data.html_url) in your web browser."
            Try {
                Start-Process $data.html_url -ErrorAction Stop
            }
            Catch {
                Throw $_
            }
        }
        elseif ($AsMarkdown) {
            [regex]$rx = "(?<=\()#\d+(?=\))"
            Write-Verbose "[$((Get-Date).TimeofDay)] Adding links to issues in the body"
            $issues = $rx.Matches($data.body)
            foreach ($issue in $issues) {
                $issnum = $issue.value -replace "\D",""
                $replace = "[$($issue.value)](https://github.com/microsoft/terminal/issues/$issnum)"
                Write-Verbose "[$((Get-Date).TimeofDay)] ... $replace"
                $data.body = $data.body -replace $issue.value,$replace
            }

            Write-Verbose "[$((Get-Date).TimeofDay)] Creating a markdown document"
        $md = @"
# $($data.name)

> Version    : $($data.tag_name)
>
> Published   : $($data.published_at -as [datetime])
>
> Pre-Release : $($data.prerelease)

$($data.body.trim())

***

*Source: $($data.html_url)*
"@
        #write the object to the pipeline
        $md
    } #as markdown
    else {
            Write-Verbose "[$((Get-Date).TimeofDay)] Creating WTReleaseNote"

            [pscustomobject]@{
                PSTypename = "WTReleaseNote"
                Name = $data.name
                Version = $data.tag_name
                Published =  $($data.published_at -as [datetime])
                Prerelease = If ($data.prerelease -eq 'true') {$True} else {$false}
                Notes = $data.body.trim()
            }
    }
    } #try
    Catch {
        Throw $_
    }
    Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($myinvocation.mycommand)"
} #end function