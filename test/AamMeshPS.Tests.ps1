$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".").Replace(".ps1","")
$baseModulePath = "$here\..\src\"

$module = Get-Module $sut

Describe 'Get-Node retrieving data' {

    Import-Module "$baseModulePath\$sut"
    Mock -ModuleName $sut Invoke-RestMethod {} -Verifiable -ParameterFilter {
        (($Uri -eq "https://mesh.aberdeen.aberdeen-asset.com/nodes/UK1DEVCHFAPP001"))
    }
    Mock -ModuleName $sut Get-Credential {}
    $domain_user = 'username'
    $domain_password = 'password' | ConvertTo-SecureString -asPlainText -Force
    $creds = New-Object System.Management.Automation.PSCredential($domain_user,$domain_password)

    Get-Node -NodeName UK1DEVCHFAPP001 -Credential $creds

    It 'Connects to mesh and pulls node information' {
	        Assert-MockCalled Invoke-RestMethod -ModuleName $sut -Exactly 1
    }

}

Describe 'Get-NodeRegion' {

    Import-Module "$baseModulePath\$sut"

    Context "When old style (e.g. UK2-D-ADM005) NodeName format is passed" {

        It "Should return the DEV environment identifier if -D- is in node name" {
            Get-NodeRegion -NodeName "UK2-D-ADM005" | Should Be "EMEA"
        }
    }

    Context "When new style (e.g. UK1DEVGENAPP222) NodeName format is passed" {

        It 'Should return the region EMEA for node with a UK1 environment prefix' {
            Get-NodeRegion -NodeName "UK1DEVCHFAPP001" | Should Be "EMEA"
        }
        It 'Should return the region EMEA for node with a UK2 environment prefix' {
            Get-NodeRegion -NodeName "UK2DEVCHFAPP001" | Should Be "EMEA"
        }
        It 'Should return the region EMEA for node with a UK3 environment prefix' {
            Get-NodeRegion -NodeName "UK3DEVCHFAPP001" | Should Be "EMEA"
        }
        It 'Should return the region EMEA for node with a UK4 environment prefix' {
            Get-NodeRegion -NodeName "UK4DEVCHFAPP001" | Should Be "EMEA"
        }

        It 'Should return the region APAC for node with a SP1 environment prefix' {
            Get-NodeRegion -NodeName "SP1DEVCHFAPP001" | Should Be "APAC"
        }
        It 'Should return the region APAC for node with a MY1 environment prefix' {
            Get-NodeRegion -NodeName "MY1DEVCHFAPP001" | Should Be "APAC"
        }
    }
}