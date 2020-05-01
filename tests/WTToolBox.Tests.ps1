
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
        } -pending

        It "Should have one or more tags" {
            $psdata.tags.count | Should BeGreaterThan 0
        } -pending

        It "Should have markdown documents folder" {
            Get-Childitem $psscriptroot\..\docs\*md | Should Exist
        } -pending

        It "Should have an external help file" {
            $cult = (Get-Culture).name
            Get-Childitem $psscriptroot\..\$cult\*-help.xml | Should Exist
        } -pending

        It "Should have a README file" {
            Get-Childitem $psscriptroot\..\README.md | Should Exist
        }

        It "Should have a License file" {
            Get-Childitem $psscriptroot\..\License.txt | Should Exist
        }
    } #Describe ModuleStructure
    Describe Backup-WTSetting {

        Context Structure {
            $thiscmd = Get-Item Function:Backup-WTSetting
            $pathParam = $thiscmd.Parameters["Path"].Attributes.where({$_.typeid.name -eq 'ParameterAttribute'})

            It "Should use cmdletbinding" {
                $thiscmd.CmdletBinding | should Be True
            }

            It "Should have documentation" {
                $h = Get-Help Backup-WTSetting
                $h.description | Should Not Be Null
                $h.examples | Should Not Be Null
            }
        } #context structure
        Context Input {
            It "should accept parameter values" {
                #insert test
            }
        } #context input
        Context Output {
            It "Should write an object to the pipeline" {
                #Insert your test
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
            It "should accept parameter values" {
                #insert test
            }
        } #context input
        Context Output {
            It "Should write an object to the pipeline" {
                #Insert your test
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
        Context Input {
            It "should accept parameter values" {
                #insert test
            }
        } #context input
        Context Output {
            It "Should write an object to the pipeline" {
                #Insert your test
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
        Context Input {
            It "should accept parameter values" {
                #insert test
            }
        } #context input
        Context Output {
            It "Should write an object to the pipeline" {
                #Insert your test
            }
        } #context output
    } #Describe Open-WTDefault

} #in module scope
