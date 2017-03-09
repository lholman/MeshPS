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

    It 'Should return the region EMEA for node with a UK1 environment prefix' {
        Get-NodeRegion -NodeName "UK1DEVCHFAPP001" | Should Be "EMEA"
    }
}