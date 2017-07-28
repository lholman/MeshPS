$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".").Replace(".ps1","")
$baseModulePath = "$here\..\src\"

$module = Get-Module $sut

Describe 'Get-NodeRegion' {

    Import-Module "$baseModulePath\$sut"

    Context "When location identifier is not as expected" {

        It "Should throw a meaningful exception when location identifier is not recognized"{
            {Get-NodeRegion -nodeName "ABCDEVGENAPP222" } | Should Throw
        }
        It 'Should return the correct region is the node name is lowercase' {
            Get-NodeRegion -NodeName "uk1devchfapp001" | Should Be "EMEA"
        }
        It 'Should ensure the location identifier is at the start of the node name and is 3 characters long' {
            {Get-NodeRegion -NodeName "ZUK1DEVCHFAPP00"} | Should Throw
        }
        It "Should throw a meaningful exception when an Azure location identifier is not recognized"{
            {Get-NodeRegion -nodeName "M15PRDADSAPP001" } | Should Throw
        }
    }

    Context "When location identifier is as expected" {

        It 'Should return the region EMEA for node with a UK1 location prefix' {
            Get-NodeRegion -NodeName "UK1DEVCHFAPP001" | Should Be "EMEA"
        }
        It 'Should return the region EMEA for node with a UK2 location prefix' {
            Get-NodeRegion -NodeName "UK2DEVCHFAPP001" | Should Be "EMEA"
        }
        It 'Should return the region EMEA for node with a UK3 location prefix' {
            Get-NodeRegion -NodeName "UK3DEVCHFAPP001" | Should Be "EMEA"
        }
        It 'Should return the region EMEA for node with a UK4 location prefix' {
            Get-NodeRegion -NodeName "UK4DEVCHFAPP001" | Should Be "EMEA"
        }
        It 'Should return the region APAC for node with a SP1 location prefix' {
            Get-NodeRegion -NodeName "SP1DEVCHFAPP001" | Should Be "APAC"
        }
        It 'Should return the region APAC for node with a MY1 location prefix' {
            Get-NodeRegion -NodeName "MY1DEVCHFAPP001" | Should Be "APAC"
        }
        It 'Should return the region AMRS for node with a US1 location prefix' {
            Get-NodeRegion -NodeName "US1DEVCHFAPP001" | Should Be "AMRS"
        }
        It 'Should return the region AMRS for node with a US2 location prefix' {
            Get-NodeRegion -NodeName "US2DEVCHFAPP001" | Should Be "AMRS"
        }
        It 'Should return the region EMEA for node with Azure lowest location prefix' {
            Get-NodeRegion -NodeName "M01PRDADSAPP001" | Should Be "EMEA"
        }
        It 'Should return the region EMEA for node with Azure highest location prefix' {
            Get-NodeRegion -NodeName "M14PRDADSAPP001" | Should Be "EMEA"
        }

    }
}

Describe "Get-NodeEnvironment parameters" {
    Import-Module "$baseModulePath\$sut"
    Context "When nodeName is null or empty" {

        It "Should throw a meaningful exception when null"{
            {Get-NodeEnvironment -NodeName "" } | Should Throw
        }
        It "Should throw a meaningful exception when empty"{
            {Get-NodeEnvironment -NodeName $null } | Should Throw
        }
    }
    Context "When NodeName parameter is passed" {

        Mock -ModuleName $sut Get-EnvironmentIdentifier {return "DEV"} -ParameterFilter {$NodeName -eq "UK2-D-ADM005"}
        $environmentIdentifier = "DEV"
        $response = Get-NodeEnvironment -NodeName "UK2-D-ADM005"

        It "Should return the expected environment identifier" {
            $response | Should Be $environmentIdentifier
        }
        It "Should call Get-EnvironmentIdentifier once to get the environment identifier from the node name" {
            Assert-MockCalled Get-EnvironmentIdentifier -ModuleName $sut -Times 1
        }
    }
}

Describe "Get-NodeEnvironment parameters" {
    Import-Module "$baseModulePath\$sut"

    Context "When old style (e.g. UK2-D-ADM005) NodeName format is passed" {

        $environmentIdentifier = "DEV"
        $response = Get-NodeEnvironment -NodeName "UK2-D-ADM005"
        It "Should return the DEV environment identifier if -D- is in node name" {
            $response | Should Be $environmentIdentifier
        }

        $environmentIdentifier = "UAT"
        $response = Get-NodeEnvironment -NodeName "UK2-U-ADM005"
        It "Should return the UAT environment identifier if -U- is in node name" {
            $response | Should Be $environmentIdentifier
        }

        $environmentIdentifier = "PRD"
        $response = Get-NodeEnvironment -NodeName "UK2-P-ADM005"
        It "Should return the PRD environment identifier if -P- is in node name" {
            $response | Should Be $environmentIdentifier
        }

        $environmentIdentifier = "PRD"
        $response = Get-NodeEnvironment -NodeName "UK2-R-ADM005"
        It "Should return the PRD environment identifier if -R- is in node name" {
            $response | Should Be $environmentIdentifier
        }

        It "Should throw a meaningful exception when environment identifier is not recognized"{
            {Get-NodeEnvironment -nodeName "UK2-Z-ADM005" } | Should Throw
        }

    }
    Context "When new style (e.g. UK1DEVGENAPP222) NodeName format is passed" {

        $environmentIdentifier = "DEV"
        $response = Get-NodeEnvironment -NodeName "UK1DEVGENAPP222"
        It "Should return the DEV environment identifier if DEV is in node name" {
            $response | Should Be $environmentIdentifier
        }

        $environmentIdentifier = "UAT"
        $response = Get-NodeEnvironment -NodeName "UK1UATGENAPP222"
        It "Should return the UAT environment identifier if UAT is in node name" {
            $response | Should Be $environmentIdentifier
        }

        $environmentIdentifier = "PRD"
        $response = Get-NodeEnvironment -NodeName "UK1PRDGENAPP222"
        It "Should return the PRD environment identifier if PRD is in node name" {
            $response | Should Be $environmentIdentifier
        }

        $environmentIdentifier = "PRD"
        $response = Get-NodeEnvironment -NodeName "UK1DRSGENAPP222"
        It "Should return the PRD environment identifier if DRS is in node name" {
            $response | Should Be $environmentIdentifier
        }

        It "Should throw a meaningful exception when environment identifier is not recognized"{
            {Get-NodeEnvironment -nodeName "UK1ABCGENAPP222" } | Should Throw
        }
    }
}

Describe 'Get-Node' {
    Import-Module "$baseModulePath\$sut"
    Context "Retrieving data" {

        Mock -ModuleName $sut Invoke-RestMethod {return "{""node"":{""uptime"":""36:45"",""name"":""UK1DEVCHFAPP001""}}"} -Verifiable

        $expectedOutput = ("{""node"":{""uptime"":""36:45"",""name"":""UK1DEVCHFAPP001""}}" | ConvertFrom-Json)

        $node = Get-Node -NodeName "UK1DEVCHFAPP001" -Verbose

        It "Returns an Object that contains the node name" {
            $node.node.name| Should Be $expectedOutput.node.name
        }
        It "Returns an Object that contains the node uptime" {
            $node.node.uptime| Should Be $expectedOutput.node.uptime
        }
    }

}