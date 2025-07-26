<#!
.SYNOPSIS
    Provides the main menu CLI and related functions for WindowsBuildCertificate.
.DESCRIPTION
    Contains the main menu logic and help/export stubs, designed for robust import and use from the entry script.
    EN-AU spelling and accessible output throughout.
.FILECREATED    2025-07-26
.FILELASTUPDATED 2025-07-26
.AUTHOR         Michael Harris
.COPYRIGHT      Copyright (c) 2025, Michael Harris, All rights reserved.
.DOCUMENTATION  https://twcau.github.io/WindowsBuildCertificate/
.NOTES          EN-AU spelling and accessible output throughout.
#>

function Show-MainMenu {
    <#
    .SYNOPSIS
        Displays the main menu and handles user selection.
    .DESCRIPTION
        Presents the main menu options and calls the appropriate submenu or action based on user input. Handles logging and menu navigation.
    .PARAMETER LogDirectory
        The directory where log files are stored.
    .PARAMETER logFile
        The current session log file path.
    .PARAMETER ConfigDirectory
        The directory where deployment configurations are stored.
    .EXAMPLE
        Show-MainMenu -LogDirectory $LogDirectory -logFile $logFile -ConfigDirectory $ConfigDirectory
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    [CmdletBinding()]
    param (
        [string]$LogDirectory,
        [string]$logFile,
        [string]$ConfigDirectory
    )
    while ($true) {
        Clear-Host
        Write-Host ("=== {0} ===" -f $Global:MenuTitle) -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Deployment Script Configuration Management"
        Write-Host "2. Export OOBE/Post-Deployment Scripts"
        Write-Host "3. Get Logs"
        Write-Host "4. Help"
        Write-Host "5. Exit"
        Write-Host ""
        $choice = Read-Host "Select an option [1-5] (default: 5)"
        if ([string]::IsNullOrWhiteSpace($choice)) { $choice = '5' }
        Write-Log -Message ("User selected main menu option {0}" -f $choice) -Level 'Action' -MenuOption $choice -LogFile $logFile
        switch ($choice) {
            '1' { Show-DeploymentMenu -ConfigDirectory $ConfigDirectory -logFile $logFile }
            '2' { Invoke-ExportScripts -logFile $logFile }
            '3' { Get-LogsMenu -LogDirectory $LogDirectory -LogFile $logFile }
            '4' { Show-HelpMenu -logFile $logFile }
            '5' { Write-Log -Message 'User exited from main menu.' -Level 'Info' -LogFile $logFile; Write-Log -Message 'Exiting...' -Level 'Info' -LogFile $logFile; Stop-Transcript; exit }
            default { Write-Log -Message ("Invalid main menu selection: {0}" -f $choice) -Level 'Warning' -LogFile $logFile; Write-Log -Message 'Invalid selection. Please choose 1-5.' -Level 'Warning' -LogFile $logFile }
        }
        if ($choice -eq '5') { break }
    }
}

function Invoke-ExportScripts {
    <#
    .SYNOPSIS
        Stub for script export logic from the main menu.
    .DESCRIPTION
        Placeholder for future implementation of script export functionality. Logs the action and prompts the user to return to the main menu.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        Invoke-ExportScripts -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param([string]$logFile)
    Write-Log -Message '[Stub] Script export logic called.' -Level 'Info' -LogFile $logFile
    Write-Log -Message '[Stub] Script export logic goes here.' -Level 'Error' -LogFile $logFile
    Write-Log -Message 'Yet to be created' -Level 'Warning' -LogFile $logFile
    Write-Log -Message 'Press enter to return to main menu' -Level 'Info' -LogFile $logFile
    Read-Host
}
