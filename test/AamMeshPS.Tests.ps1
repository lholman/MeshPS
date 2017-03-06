$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".").Replace(".ps1","")
$baseModulePath = "$here\..\src\"

$module = Get-Module $sut

Describe 'Get-Node retrieving data' {

    Import-Module "$baseModulePath\$sut"
    Mock -ModuleName $sut Get-Node {} -Verifiable -ParameterFilter {
        (())
    }