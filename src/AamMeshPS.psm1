function Get-Node {
     [CmdletBinding()]
     Param(
            [Parameter(Mandatory = $True)]
                [String]
                $NodeName,
            [Parameter(Mandatory = $False)]
                [PSCredential]
                $Credential
     )

        $creds = ""
        if ($Credential)
        {
            $creds = $Credential
        }else{
            $creds = Get-Credential
        }

        return Invoke-RestMethod -Uri "https://mesh.aberdeen.aberdeen-asset.com/nodes/$NodeName" -Method GET -Credential $creds
}

<#

.SYNOPSIS
    Given a node name will return the corresponding region name based on the node names location identifier.
.DESCRIPTION
    Given a node name in the old (e.g. UK2-D-ADM005) or new (e.g. UK1DEVGENAPP222) style will return the corresponding region name based on the node names location identifier.
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

           switch -wildcard ($NodeName)
            {
                "UK[1-4]" {return "EMEA"}
                "SP1" {return "APAC"}
                "MY1" {return "APAC"}
                "US[1-2]" {return "AMRS"}
                "M01" {return "EMEA"}
                default {Throw "Error: Get-NodeRegion: Unrecognized environment identifier within node name"}
            }

}

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

process {
        switch -regex ($NodeName)
        {
            "DEV|-D-" {return "DEV";break}
            "UAT|-U-" {return "UAT";break}
            "PRD|DRS|-P-|-R-" {return "PRD";break}
            default {Throw "Error: Get-EnvironmentFromNodeName:Get-EnvironmentIdentifier: Unrecognized environment identifier within node name"}
        }
    }
}

Export-ModuleMember -Function Get-Node, Get-NodeRegion, Get-NodeEnvironment
