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

           switch -wildcard ($NodeName)
            {
                "*UK1*" {return "EMEA"}
                default {Throw "Error: Get-NodeRegion: Unrecognized environment identifier within node name"}
            }

}

Export-ModuleMember -Function Get-Node, Get-NodeRegion
