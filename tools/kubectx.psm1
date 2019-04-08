Function Get-KubectlContexts {
    [CmdletBinding()]
    Param ()
    DynamicParam {
        # Set up the Run-Time Parameter Dictionary
        $DynamicParamDict = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Begin dynamic parameter definition
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $false
        $ParameterAttribute.Position = 0
        $AttributeCollection.Add($ParameterAttribute)
        $ValidationValues = kubectl config get-contexts -o=name
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($ValidationValues)
        $AttributeCollection.Add($ValidateSetAttribute)
        $ParamName = 'Context'
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParamName, [string], $AttributeCollection)
        $DynamicParamDict.Add($ParamName, $RuntimeParameter)
        # End Dynamic parameter definition

        # When done building dynamic parameters, return
        return $DynamicParamDict
    }
    process {
        if ($PSBoundParameters.Context) {
            kubectl config use-context $PSBoundParameters.Context
        } else {
            $activeCtx = kubectl config current-context
            foreach ($ctx in $(kubectl config get-contexts -o name)) {
                if ($ctx -eq $activeCtx) {
                    Write-Host $ctx -BackgroundColor "DarkRed"
                } 
                else { 
                    Write-Host $ctx
                }
            }
        }
    }
}
New-Alias kubectx Get-KubectlContexts
New-Alias kcx Get-KubectlContexts
Export-ModuleMember -Function 'Get-KubectlContexts' -Alias *