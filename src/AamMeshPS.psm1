<#

.SYNOPSIS
    Given a node name will return the corresponding region name based on the node names location identifier.
.DESCRIPTION
    Given a node name in the format UK1DEVGENAPP222 will return the corresponding region name based on the node names location identifier.
.NOTES
	Requirements: Copy this module to any location found in $env:PSModulePath
.PARAMETER NodeName
    Mandatory. The node name to retrieve the region for
.EXAMPLE
	Import-Module AamMeshPS
	Import the module
.EXAMPLE
	Get-Command -Module AamMeshPS
    Get-NodeRegion -NodeName "UK1DEVCHFAPP001"
.EXAMPLE
#>
function Get-NodeRegion {
	[CmdletBinding()]
	[OutputType([String])]
    Param(
        [Parameter(Mandatory = $True,
            HelpMessage="Please supply a value for NodeName" )]
            [ValidateNotNullOrEmpty()]
            [String]
            $NodeName
        )

        $NodeName = $NodeName.ToUpper()
        $NodeName = $NodeName.SubString(0,3)

        switch -regex ($NodeName)
        {
            "^UK[1-4]" {return "EMEA"}
            "^SP1" {return "APAC"}
            "^MY1" {return "APAC"}
            "^US[1-2]" {return "AMRS"}
            "^M0[1-9]|1[0-4]$" {return "EMEA"}
            default {Throw "Error: Get-NodeRegion: Unrecognized environment identifier within node name"}
        }
}

<#
.SYNOPSIS
    Wrapper function. Given a node name will return the corresponding environment name based on the node names environment identifier.
.DESCRIPTION
    Given a node name in the old (e.g. UK2-D-ADM005) or new (e.g. UK1DEVGENAPP222) style will return the corresponding environment name based on the node names environment identifier
.NOTES
	Requirements: Copy this module to any location found in $env:PSModulePath
.PARAMETER NodeName
    Mandatory. The node name to retrieve the region for
.EXAMPLE
	Import-Module AamMeshPS
	Import the module
.EXAMPLE
	Get-Command -Module AamMeshPS
    Get-NodeRegion -NodeName "UK1DEVCHFAPP001"
#>
function Get-NodeEnvironment {
	[CmdletBinding()]
	[OutputType([String])]
    Param(
        [Parameter(Mandatory = $True,
            HelpMessage="Please supply a value for NodeName" )]
            [ValidateNotNullOrEmpty()]
            [String]
            $NodeName
        )

     return Get-EnvironmentIdentifier -NodeName $NodeName

}


<#
.SYNOPSIS
    Given a node name will return the corresponding environment name based on the node names environment identifier.
.DESCRIPTION
    Given a node name in the old (e.g. UK2-D-ADM005) or new (e.g. UK1DEVGENAPP222) style will return the corresponding environment name based on the node names environment identifier
.NOTES
	Requirements: Copy this module to any location found in $env:PSModulePath
.PARAMETER NodeName
    Mandatory. The node name to retrieve the region for
.EXAMPLE
	Import-Module AamMeshPS
	Import the module
.EXAMPLE
	Get-Command -Module AamMeshPS
    Get-NodeRegion -NodeName "UK1DEVCHFAPP001"
#>
function Get-EnvironmentIdentifier {
	[CmdletBinding()]
	[OutputType([String])]
    Param(
        [Parameter(Mandatory = $True,
            HelpMessage="Please supply a value for NodeName" )]
            [ValidateNotNullOrEmpty()]
            [String]
            $NodeName
        )

    switch -regex ($NodeName)
    {
        "DEV|-D-" {return "DEV";break}
        "UAT|-U-" {return "UAT";break}
        "PRD|DRS|-P-|-R-" {return "PRD";break}
        default {Throw "Error: Get-NodeEnvironment:Get-EnvironmentIdentifier: Unrecognized environment identifier within node name"}
    }
}

Export-ModuleMember -Function Get-NodeRegion, Get-NodeEnvironment
