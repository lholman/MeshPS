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
Export-ModuleMember -Function Get-Node
