<#!
.SYNOPSIS
    Functions for Active Directory configuration checks.
.DESCRIPTION
    Contains functions to validate device state with respect to on-premises Active Directory join status.
.FILECREATED    2025-07-27
.FILELASTUPDATED 2025-07-27
.AUTHOR         Michael Harris
.COPYRIGHT      Copyright (c) 2025, Michael Harris, All rights reserved.
.DOCUMENTATION  https://twcau.github.io/WindowsBuildCertificate/
.NOTES          EN-AU spelling and accessible output throughout.
#>

function Test-OnPremADJoin {
    <#
    .SYNOPSIS
        Checks if the device is joined to On-Premises Active Directory.
    .DESCRIPTION
        Returns 0 if joined, 1 if not joined, 2 if error. Logs all actions and results.
    .EXAMPLE
        Test-OnPremADJoin
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    [CmdletBinding()]
    param ()
    try {
        $domain = (Get-WmiObject -Class Win32_ComputerSystem).Domain
        if ($domain -and $domain -ne $env:COMPUTERNAME) {
            Write-Log -Message 'Device is joined to On-Premises AD.' -Level 'Info'
            return 0
        }
        else {
            Write-Log -Message 'Device is NOT joined to On-Premises AD.' -Level 'Warning'
            return 1
        }
    }
    catch {
        Write-Log -Message ('Error checking AD join status: {0}' -f $_) -Level 'Error'
        return 2
    }
}
