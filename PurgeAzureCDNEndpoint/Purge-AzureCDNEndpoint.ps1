Trace-VstsEnteringInvocation $MyInvocation

try {
    # Get user inputs
    $ResourceGroupName = Get-VstsInput -Name ResourceGroupName -Require
    $EndpointName = Get-VstsInput -Name EndpointName -Require
    $ProfileName = Get-VstsInput -Name ProfileName -Require
    $PurgeContent = Get-VstsInput -Name PurgeContent -Require

    # Initialize Azure.
    Import-Module $PSScriptRoot\ps_modules\VstsAzureHelpers_
    Initialize-Azure
    
    # For compatibility with the legacy handler implementation, set the error action
    # preference to continue. An implication of changing the preference to Continue,
    # is that Invoke-VstsTaskScript will no longer handle setting the result to failed.
    $global:ErrorActionPreference = 'Continue'
    
    $strPurgeContent = $PurgeContent.Replace("`r", "").Replace("`n", "', '")
    $arrayPurgeContent = $PurgeContent.Replace("`r", "").Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)

    Write-Host "##[command] Unpublish-AzureRmCdnEndpointContent -ResourceGroupName $ResourceGroupName -ProfileName $ProfileName -EndpointName $EndpointName -PurgeContent @( '$strPurgeContent' )"
    Unpublish-AzureRmCdnEndpointContent -ResourceGroupName $ResourceGroupName -ProfileName $ProfileName -EndpointName $EndpointName -PurgeContent $arrayPurgeContent

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}

