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

    # Remove all commands imported from VstsTaskSdk, other than Out-Default.
    # Remove all commands imported from VstsAzureHelpers_.
    Get-ChildItem -LiteralPath function: |
    Where-Object {
        ($_.ModuleName -eq 'VstsTaskSdk' -and $_.Name -ne 'Out-Default') -or
        ($_.Name -eq 'Invoke-VstsTaskScript') -or
        ($_.ModuleName -eq 'VstsAzureHelpers_' )
    } |
    Remove-Item
    
    # For compatibility with the legacy handler implementation, set the error action
    # preference to continue. An implication of changing the preference to Continue,
    # is that Invoke-VstsTaskScript will no longer handle setting the result to failed.
    $global:ErrorActionPreference = 'Continue'

    Write-Host "##[command]Unpublish-AzureRmCdnEndpointContent -ResourceGroupName $ResourceGroupName -ProfileName $ProfileName -EndpointName $EndpointName -PurgeContent $PurgeContent"
    Unpublish-AzureRmCdnEndpointContent -ResourceGroupName $ResourceGroupName -ProfileName $ProfileName -EndpointName $EndpointName -PurgeContent $PurgeContent

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}

