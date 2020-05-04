
# Import the parent module to test

if (Get-Module -Name WTToolBox) {
    Remove-Module -Name WTToolBox
}

Import-Module "$PSScriptRoot\..\WTToolBox.psd1" -force

InModuleScope WTToolBox {
    Describe 'ModuleStructure' {

        It 'Passes Test-ModuleManifest' {
            {Test-ModuleManifest -Path "$PSScriptRoot\..\WTToolBox.psd1"} | Should Not Throw True
        }

        $psdata = (Get-Module WTToolBox).PrivateData.psdata
        It "Should have a project uri" {
            $psdata.projecturi | Should Match "^http"
        }

        It "Should have one or more tags" {
            $psdata.tags.count | Should BeGreaterThan 0
        }

        It "Should have markdown documents folder" {
            Get-Childitem $psscriptroot\..\docs\*md | Should Exist
        }

        It "Should have an external help file" {
            $cult = (Get-Culture).name
            Get-Childitem $psscriptroot\..\$cult\*-help.xml | Should Exist
        }

        It "Should have a README file" {
            Get-Childitem $psscriptroot\..\README.md | Should Exist
        }

        It "Should have a License file" {
            Get-Childitem $psscriptroot\..\License.* | Should Exist
        }
    } #Describe ModuleStructure

    Describe Backup-WTSetting {

            Mock Test-Path {$True}

             Mock -CommandName Get-Childitem -MockWith {
                "foo" | Out-file TestDrive:\settings.bak2.json
                Get-Item TestDrive:\settings.bak2.json
            } -ParameterFilter {$Path -eq "$env:temp\settings.bak*.json"}

            Mock Copy-Item {}
            Mock Remove-Item {}

        Context Structure {
            $thiscmd = Get-Item -path Function:Backup-WTSetting
            $pathParam = $thiscmd.Parameters["Path"].Attributes.where({$_.typeid.name -eq 'ParameterAttribute'})

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | should Be True
            }

            It "Should support -WhatIf" {
                $thiscmd.Parameters["WhatIf"].SwitchParameter | Should Be True
            }

            It "Should have documentation" {
                $h = Get-Help Backup-WTSetting
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }

            $p1 = (Get-Command Backup-WTSetting).parameters["Destination"].attributes | where-object {$_.typeid.name -match "ParameterAttribute"}
            It "The Destination parameter should be mandatory" {
              $p1.Mandatory | Should Be $True
            }
        } #context structure

        Context Input {

            #create a sample backup file
             $foo = New-Item TestDrive:\settings.bak1.json
             $foo.LastWriteTime = [datetime]"5/1/2020 12:00PM"

            It "should accept a destination value" {
                {Backup-WTSetting -Destination TESTDRIVE:\} | Should Not Throw
            }
            It "Should run Test-Path" {
                Assert-MockCalled "Test-Path" -Scope Context
            }
            It "Should run Get-Childitem" {
                Assert-MockCalled "Get-ChildItem" -Scope Context
            }
            It "Should run Copy-Item" {
                Assert-MockCalled "Copy-Item" -Times 2 -Scope Context
            }

            It "Should run Remove-Item" {
                Assert-MockCalled "Remove-Item" -Times 1 -Scope Context
            }
        } #context input

        Context Output {

             #create a sample backup file
             $foo = New-Item TestDrive:\settings.bak1.json
             $foo.LastWriteTime = [datetime]"5/1/2020 12:00PM"

            It "Should write a file object to the pipeline with -Passthru" {
                $r = Backup-WTSetting -Destination TESTDRIVE:\ -passthru
                #$r | out-string | write-host
                $r.count | should be 1
                $r[0] | Should BeOfType system.io.fileinfo
            }
        } #context output
    } #Describe Backup-WTSetting

    Describe Get-WTKeyBinding {

        Context Structure {
            $thiscmd = Get-Item Function:Get-WTKeyBinding
            $pathParam = $thiscmd.Parameters["Path"].Attributes.where({$_.typeid.name -eq 'ParameterAttribute'})

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | should Be True
            }

            It "Should have documentation" {
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

            mock parsesetting {
               @{
                Action = "closeWindow"
                ActionSettings = $null
                Keys = "alt+f4"
                Source = "defaults"
              }
            }
            Mock Get-Content {
                  $fake = @"
{
"keybindings":
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
return $fake
            } -ParameterFilter {$Path -eq "Testdrive:\defaults.json" }

            Mock Get-Content { } -ParameterFilter {$Path -eq "$ENV:Userprofile\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"}
            Mock Get-Appxpackage {
               @{InstallLocation = "TestDrive:"}
            } -ParameterFilter {$Name -eq 'Microsoft.WindowsTerminal'}

            Mock Join-Path {
                 "Testdrive:\defaults.json"
            } -ParameterFilter {$Path -eq "Testdrive:" -AND $childpath -eq "defaults.json" }

            $f = Get-WTKeybinding
            It "Should call Get-AppxPackage" {
                Assert-MockCalled "Get-AppxPackage" -Scope Context
            }
            It "Should call Join-Path" {
                Assert-MockCalled "Join-Path" -Scope Context
            }
            It "Should call Get-Content" {
                Assert-MockCalled Get-Content -Times 2 -Scope Context
            }

            It "Should parse settings with a private function" {
                Assert-MockCalled parsesetting -Times 6 -Scope context
            }
            It "Should write an object to the pipeline" {
               $f.count | Should be 6
               $f[0].keys -contains "Action" | Should be True
               $f[0].keys -contains "ActionSettings" | Should be True
               $f[0].keys -contains "Source" | Should be True
               $f[0].keys -contains "Keys" | Should be True
            }

            It "Should format result as a table" {
                Mock Format-Table {}
                {Get-WTKeybinding -Format Table} | Should Not Throw
                Assert-MockCalled Format-Table -times 1
            }
            It "Should format result as a list" {
               Mock Format-List {}
                {Get-WTKeybinding -Format List} | Should Not Throw
                Assert-MockCalled Format-List -times 1
            }
            It "Should send results to Out-Gridview" {
                Mock Out-GridView {}
                {Get-WTKeybinding -Format Grid} | Should Not Throw
                Assert-MockCalled Out-Gridview -times 1
            }
        } #context output
    } #Describe Get-WTKeyBinding

    Describe Get-WTProcess {

        Context Structure {
            $thiscmd = Get-Item Function:Get-WTProcess
            $pathParam = $thiscmd.Parameters["Path"].Attributes.where({$_.typeid.name -eq 'ParameterAttribute'})

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | should Be True
            }

            It "Should have documentation" {
                $h = Get-Help Get-WTProcess
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }
        } #context structure

        Context Output {

            $pid = 100
            Mock Get-CimInstance {
                  @{ParentProcessID=123}
            } -ParameterFilter {$Classname -eq "Win32_Process" -AND $filter -eq "ProcessID=$PID"}

            Mock Get-CimInstance {
                 return  @(@{ProcessID = 300},@{ProcessID=200})
            } -ParameterFilter {$Classname -eq "Win32_Process" -AND $filter -eq "ParentProcessID = 123" -AND $Property -eq "ProcessID"}

            Mock Get-Process {
                @{ProcessName = "WindowsTerminal"}
            } -ParameterFilter {$ID -eq 123}

            Mock Get-Process {
                @{ProcessName = "powershell"}
            } -ParameterFilter {$ID -eq 200}

            Mock Get-Process {
                @{ProcessName = "pwsh"}
            } -ParameterFilter {$ID -eq 300}

            $r = Get-WTProcess

            It "Should call Get-Ciminstance" {
                Assert-MockCalled Get-Ciminstance -Times 2 -Scope context
            }
            It "Should call Get-Process" {
                Assert-MockCalled Get-Process -Times 3 -Scope context
            }
            It "Should write an object to the pipeline" {
                $r.count | Should be 3
            }

            It "Should write a warning if not running in Windows Terminal" {
              Mock Get-CimInstance {} -ParameterFilter {$Classname -eq "Win32_Process" -AND $filter -eq "ProcessID=$PID"}

               Get-WTProcess -WarningAction SilentlyContinue -WarningVariable w
               $w | Should be "This instance of PowerShell doesn't appear to be running in Windows Terminal."
            }
        } #context output

    } #Describe Get-WTProcess

    Describe Open-WTDefault {

        Context Structure {
            $thiscmd = Get-Item Function:Open-WTDefault
            $pathParam = $thiscmd.Parameters["Path"].Attributes.where({$_.typeid.name -eq 'ParameterAttribute'})

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | should Be True
            }

            It "Should have documentation" {
                $h = Get-Help Open-WTDefault
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }
        } #context structure

        Context Output {

            It "Should throw an exception if Windows Terminal is not installed" {
                Mock Get-AppxPackage {}
                {Open-WTDefault} | Should Throw
            }
            It "Should write a warning if default.json is missing" {
                Mock Get-AppxPackage {
                    @{InstallLocation = "Testdrive:\"}
                }
                Mock Test-Path {$False} -ParameterFilter {$Path -eq "Testdrive:\" -AND $ChildPath -eq 'defaults.json'}
                Open-WTDefault -WarningAction SilentlyContinue -WarningVariable w
                $w | Should be "Could not find default.json file."
            }
            It "Should open the file with Invoke-Item" {
                Mock Test-Path {$True}
                Mock Invoke-Item {}
                {Open-WTDefault} | Should not Throw
                Assert-MockCalled Invoke-Item -Times 1
            }
        } #context output
    } #Describe Open-WTDefault

} #in module scope
