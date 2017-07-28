<#

.SYNOPSIS
    Given a node name will return the corresponding region name based on the node names location identifier.
.DESCRIPTION
    Given a node name in the format UK1DEVGENAPP222 will return the corresponding region name based on the node names location identifier.
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

    Throw "Error: Get-NodeEnvironment:Get-EnvironmentIdentifier: Unrecognized environment identifier within node name"
}

<#
.SYNOPSIS
    Given a node name will return a custom PSObject containing the node name, environment and region names
.DESCRIPTION
   Given a node name will return a custom PSObject containing the node name, environment and region names
#>
function Get-Node {
     [CmdletBinding()]
     [OutputType([PSCustomObject])]
     Param(
            [Parameter(Mandatory = $True)]
                [String]
                $NodeName
     )

        $nodeJson = Get-NodeJson -NodeName $NodeName
        return ConvertTo-NodeObject -Json $nodeJson
}

function Get-NodeJson {
    [CmdletBinding()]
    [OutputType([String])]
    Param(
            [Parameter(Mandatory = $True)]
                [String]
                $NodeName
	)

        return Invoke-RestMethod -Uri "https://mesh.webapp.com/nodes/$NodeName" -Method GET
}

function ConvertTo-NodeObject {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
	Param(
		[Parameter(
			Mandatory=$True,
			HelpMessage="Please supply some JSON to validate" )]
			[ValidateNotNullOrEmpty()]
			[String]
			$Json
	)

        if (Confirm-ValidJson -Json $nodeJson)
        {
            $nodeObject = ($Json | ConvertFrom-Json)
            return $nodeObject
        }
}

function Confirm-ValidJson {
    [CmdletBinding()]
    [OutputType([Boolean])]
	Param(
		[Parameter(
			Mandatory=$True,
			HelpMessage="Please supply some JSON to validate" )]
			[ValidateNotNullOrEmpty()]
			[String]
			$Json
	)

	try {
		return $Json | ConvertFrom-Json
	}
	catch {
		Write-Error "Error: Invalid Json string: $Json"
	}
}



Export-ModuleMember -Function Get-NodeRegion, Get-NodeEnvironment, Get-Node
