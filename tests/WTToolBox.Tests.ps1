
# Import the parent module to test

if (Get-Module -Name WTToolBox) {
    Remove-Module -Name WTToolBox
}

Import-Module "$PSScriptRoot\..\WTToolBox.psd1" -Force

InModuleScope WTToolBox {
    Describe 'ModuleStructure' {

        It 'Passes Test-ModuleManifest' {
            { Test-ModuleManifest -Path "$PSScriptRoot\..\WTToolBox.psd1" } | Should Not Throw True
        }

        It "Should export 16 functions" {
            ( (Get-Module WTToolbox).ExportedFunctions).count | Should Be 16
        }

        $psdata = (Get-Module WTToolBox).PrivateData.psdata
        It "Should have a project uri" {
            $psdata.projecturi | Should Match "^http"
        }

        It "Should have one or more tags" {
            $psdata.tags.count | Should BeGreaterThan 0
        }

        It "Should have markdown documents folder" {
            Get-ChildItem $psscriptroot\..\docs\*md | Should Exist
        }

        It "Should have an external help file" {
            $cult = (Get-Culture).name
            Get-ChildItem $psscriptroot\..\$cult\*-help.xml | Should Exist
        }

        It "Should have a README file" {
            Get-ChildItem $psscriptroot\..\README.md | Should Exist
        }

        It "Should have a License file" {
            Get-ChildItem $psscriptroot\..\License.* | Should Exist
        }
    } #Describe ModuleStructure

    Describe Install-WTRelease {

        Context Structure {
            $thiscmd = Get-Item -Path Function:Install-WTRelease

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | Should Be True
            }

            It "Should support -WhatIf" {
                $thiscmd.Parameters["WhatIf"].SwitchParameter | Should Be True
            }

            It "Should have a -Preview parameter" {
                $thiscmd.Parameters["Preview"].SwitchParameter | Should Be True
            }

            It "Should have help documentation" {
                $h = Get-Help Install-WTRelease
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }
        } #context structure
    }
    Describe Backup-WTSetting {

        Mock Test-Path { $True }

        Mock -CommandName Get-Childitem -MockWith {
            "foo" | Out-File TestDrive:\settings.bak2.json
            Get-Item TestDrive:\settings.bak2.json
        } -ParameterFilter { $Path -eq "$env:temp\settings.bak*.json" }

        Mock Copy-Item {}
        Mock Remove-Item {}

        Context Structure {
            $thiscmd = Get-Item -Path Function:Backup-WTSetting

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | Should Be True
            }

            It "Should support -WhatIf" {
                $thiscmd.Parameters["WhatIf"].SwitchParameter | Should Be True
            }

            It "Should have help documentation" {
                $h = Get-Help Backup-WTSetting
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }

            $p1 = (Get-Command Backup-WTSetting).parameters["Destination"].attributes | Where-Object { $_.typeid.name -match "ParameterAttribute" }
            It "The Destination parameter should be mandatory" {
                $p1.Mandatory | Should Be $True
            }
        } #context structure

        Context Input {

        } #context input

        Context Output {

        } #context output

    } #Describe Backup-WTSetting

    Describe Get-WTCurrentRelease {

        Context Structure {
            $thiscmd = Get-Item -Path Function:\Get-WTCurrentRelease

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | Should Be True
            }

            It "Should have a -Preview parameter" {
                $thiscmd.Parameters["Preview"].SwitchParameter | Should Be True
            }

            It "Should have help documentation" {
                $h = Get-Help Get-WTCurrentRelease
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }

        } #context structure
        Context Input {}

        Context Output {}
    }
    Describe Get-WTKeyBinding {

        Context Structure {
            $thiscmd = Get-Item Function:Get-WTKeyBinding

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | Should Be True
            }

            It "Should have help documentation" {
                $h = Get-Help Get-WTKeyBinding
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }
        } #context structure
        Context Input {

            $param = (Get-Command get-wtkeybinding).parameters["Format"]

            It "The Format parameter should have parameter validation" {
                $param.Attributes.TypeID.Name -contains 'ValidateSetAttribute'
            }
            It "The -Format parameter has an alias of 'out'" {
                $param.Aliases -contains "out"
            }
        } #context input
        Context Output {

            $global:wtSettingsPath = "Testdrive:\settings.json"

            $defaultContent = @"
{
    "defaultProfile": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
    "actions":
    [
        { "command": "closeWindow", "keys": "alt+f4" },
        { "command": "toggleFullscreen", "keys": "alt+enter" },
        { "command": "toggleFullscreen", "keys": "f11" },
        { "command": "openNewTabDropdown", "keys": "ctrl+shift+space" },
        { "command": "openSettings", "keys": "ctrl+," },
        { "command": "find", "keys": "ctrl+shift+f" }
        ]
}
"@
            $defaultContent | Out-File "Testdrive:\defaults.json"
            Mock Get-WTProcess {}
            Mock parsesetting {
                @{
                    Action         = "closeWindow"
                    ActionSettings = $null
                    Keys           = "alt+f4"
                    Source         = "defaults"
                }
            }

            Mock Get-Content { } -ParameterFilter { $Path -eq "Testdrive:\settings.json" }
            Mock Get-AppxPackage {
                @{ Name             = "Microsoft.WindowsTerminal"
                    Version         = "1.4.3243.0"
                    InstallLocation = "TestDrive:"
                }
            } -ParameterFilter { $Name -eq 'Microsoft.WindowsTerminal' }

            Mock Join-Path {
                "Testdrive:\defaults.json"
            } -ParameterFilter { $Path -eq "Testdrive:" -AND $childpath -eq "defaults.json" }
            Mock Test-Path { $True }

            $f = Get-WTKeyBinding
            It "Should call Get-AppxPackage" {
                Assert-MockCalled "Get-AppxPackage" -Scope Context
            }
            It "Should call Join-Path" {
                Assert-MockCalled "Join-Path" -Scope Context
            }
            It "Should call Get-Content" {
                Assert-MockCalled Get-Content -Scope Context
            }

            It "Should parse settings with a private function" {
                Assert-MockCalled parsesetting -Scope context
            }
            It "Should write an object to the pipeline" {
                $f.count | Should be 6
                $f[0].keys -contains "Action" | Should be True
                $f[0].keys -contains "ActionSettings" | Should be True
                $f[0].keys -contains "Source" | Should be True
                $f[0].keys -contains "Keys" | Should be True
                $f[0].psobject.typenames[0] | Should be "wtKeyBinding"
            }

            $g = Get-WTKeybinding -action "close*"
            It "Should get a specific action" {
                $g.values.count | should be 4
                $g.values -contains "closeWindow"
            }

        } #context output
    } #Describe Get-WTKeyBinding

    Describe Get-WTProcess {

        Context Structure {
            $thiscmd = Get-Item Function:Get-WTProcess

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | Should Be True
            }

            It "Should have help documentation" {
                $h = Get-Help Get-WTProcess
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }
        } #context structure

        Context Output {

            Mock Get-CimInstance {
                [pscustomobject]@{ParentProcessID = 123 }
            } -ParameterFilter { $Classname -eq "Win32_Process" -AND $filter -eq "ProcessID=$pid" }

            Mock Get-CimInstance {
                @([pscustomobject]@{ProcessID = 300 }, [pscustomobject]@{ProcessID = 200 })
            } -ParameterFilter { $Classname -eq "Win32_Process" -AND $filter -eq "ParentProcessID = 123" -AND $Property -eq "ProcessID" }

            Mock Get-Process {
                [pscustomobject]@{ProcessName = "WindowsTerminal";ID=123 }
            } -ParameterFilter { $ID -eq 123 }

            Mock Get-Process {
                [pscustomobject]@{ProcessName = "powershell" }
            } -ParameterFilter { $ID -eq 200 }

            Mock Get-Process {
                [pscustomobject]@{ProcessName = "pwsh" }
            } -ParameterFilter { $ID -eq 300 }

            $r = Get-WTProcess

            It "Should call Get-Ciminstance 2 times" {
                Assert-MockCalled Get-Ciminstance -Times 2 -Scope context
            }
            It "Should call Get-Process 3 times" {
                Assert-MockCalled Get-Process -Times 3 -Scope context
            }
            It "Should write 3 objects to the pipeline" {
                $r.count | Should be 3
            }

            It "Should write a custom object type of WTProcess" {
                $r[0].psobject.typenames | Should contain "WTProcess"
            }

            It "Should write a warning if not running in Windows Terminal" {

                Mock Get-Process {
                    [pscustomobject]@{ProcessName = "Foo" }
                } -ParameterFilter { $ID -eq 123 }

                Get-WTProcess -WarningAction SilentlyContinue -WarningVariable w
                $w | Should match "\w+"
            }
        } #context output

    } #Describe Get-WTProcess

    Describe Open-WTDefault {

        Context Structure {
            $thiscmd = Get-Item Function:Open-WTDefault

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | Should Be True
            }

            It "Should have help documentation" {
                $h = Get-Help Open-WTDefault
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }
        } #context structure

        Context Output {

            Mock Get-WTProcess {}
            It "Should throw an exception if Windows Terminal is not installed" {
                { Open-WTDefault } | Should Throw
            }
            It "Should write a warning if default.json is missing" {
                Mock Get-WTProcess {
                    [pscustomobject]@{Name = "WindowsTerminal"; Path = "TestDrive:\windowsTerminal" }
                }

                Mock Test-Path { $False }
                Open-WTDefault -WarningAction SilentlyContinue -WarningVariable w
                $w | Should match "\w+"
            }
            It "Should open the file with Invoke-Item" {
                Mock Get-WTProcess {
                    [pscustomobject]@{Name = "WindowsTerminal"; Path = "TestDrive:\windowsTerminal" }
                }
                Mock Test-Path { $True }
                Mock Invoke-Item {}
                { Open-WTDefault } | Should not Throw
                Assert-MockCalled Invoke-Item -Times 1
            }
        } #context output
    } #Describe Open-WTDefault

    Describe "Test-WTVersion" {
        Context Structure {
            $thiscmd = Get-Item Function:Test-WTVersion

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | Should Be True
            }

            It "Should have help documentation" {
                $h = Get-Help Test-WTVersion
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }
        }

        Context Output {

            Mock Test-Path { $True }
            Mock Get-Content {
                @"
{
"VersionString": "1.0.0"
}
"@

            } -ParameterFilter { $Path -eq "$home\wtver.json" }
            Mock ConvertTo-Json {}
            Mock Out-File {}

            It "Should throw an exception if Windows Terminal is not Installed" {
                Mock Get-AppXPackage {}
                { Test-WTVersion } | Should Throw
            }

            It "Should return a boolean result" {
                Mock Get-AppXPackage { @{Version = "1.0.1" } }
                Test-WTVersion | Should be True
            }
        }
    } #describe test-WTVersion

    Describe 'Get-WTReleaseNote' {
        Context Structure {

            $thiscmd = Get-Item Function:Get-WTReleaseNote

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | Should Be True
            }

            It "Should have help documentation" {
                $h = Get-Help Get-WTReleaseNote
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }

            It "Has a parameter called AsMarkdown" {
                $thiscmd.parameters.keys -contains "AsMarkdown" | Should be True
            }

            It "The AsMarkdown parameter has an alias of md" {
                $thiscmd.parameters["AsMarkdown"].Aliases -contains "md" | Should Be True
            }

            It "Has a parameter called Online" {
                $thiscmd.parameters.keys -contains "Online" | Should be True
            }
        }

        Context Output {
            Mock Invoke-RestMethod {
                [pscustomobject]@{
                    prerelease   = $False
                    name         = "Windows Terminal"
                    published_at = "2020-05-05T22:25:47Z"
                    tag_name     = "v0.11.0"
                    html_url     = "http://localhost"
                    body         = "foo"
                    bodylength   = 123
                }
            }
            Mock Start-Process {}

            $r = Get-WTReleaseNote

            It "Should call Invoke-RestMethod" {
                Assert-MockCalled Invoke-RestMethod -Times 1
            }
            It "Should create a custom object" {
                $r | Should BeofType "PSCustomObject"
                $r.name | Should be "Windows Terminal"
                $r.Version | Should be "v0.11.0"
                $r.Notes | Should be "foo"
                $r.prerelease | Should be "false"
                $r.prerelease | Should BeOfType "boolean"
                $r.published | Should  BeOfType "DateTime"
            }

            It "Should create a string object for markdown" {
                $md = Get-WTReleaseNote -AsMarkdown
                $md | Should BeofType "string"
            }

            It "Should call Start-Process to open an online link" {
                Get-WTReleaseNote -Online
                Assert-MockCalled "Start-Process" -Times 1
            }
            It "Should throw an exception if GitHub can't be reached" {
                Mock Invoke-RestMethod {}
                { Get-WTReleaseNote } | Should Throw
            }
        }

    } #describe Get-WTReleaseNote

    Describe 'Get-WTCurrent' {

        Context Structure {

            $thiscmd = Get-Item Function:Get-WTCurrent

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | Should Be True
            }

            It "Should have help documentation" {
                $h = Get-Help Get-WTCurrent
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }

            It "Has no additional parameters" {
                $thiscmd.parameters.keys.count | Should be 11
            }
        }

        It "Should write a warning if there is no WT_PROFILE_ID variable" {
            #save the current id if exists so it can be saved
            $save = $env:WT_PROFILE_ID
            $env:WT_PROFILE_ID = $null
            Get-WTCurrent -WarningAction SilentlyContinue -WarningVariable w
            $w | Should BeOfType [System.Management.Automation.WarningRecord]

            $env:WT_PROFILE_ID = $save
        }

    } #describe Get-WTCurrent

    Describe Test-IsWTPreview {

        Context Structure {
            $thiscmd = Get-Item -Path Function:\Test-IsWTPreview

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | Should Be True
            }

            It "Should have help documentation" {
                $h = Get-Help Test-IsWTPreview
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }
        } #context
        Context Output {
            Mock Get-CimInstance {
                [pscustomobject]@{ParentProcessID = 123 }
            } -ParameterFilter { $Classname -eq "Win32_Process" -AND $filter -eq "ProcessID=$pid" }
            Mock Get-CimInstance {
                [pscustomobject]@{ExecutablePath = "C:\Foo\WindowsTerminal.exe" }
            } -ParameterFilter { $Classname -eq "Win32_Process" -AND $filter -eq "ProcessID=123" }

            $t = Test-IsWTPreview
            It "Should call Get-CimInstance" {
                Assert-MockCalled Get-Ciminstance -scope context
            }
            It "Should return false if not running Windows Terminal Preview" {
                $t | Should Be $False
            }
        }
    } #describe Test-IsWTVersion

} #in module scope
