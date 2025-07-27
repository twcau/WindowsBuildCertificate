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
        Write-Host "2. Get Logs"
        Write-Host "3. Help"
        Write-Host "4. Exit"
        Write-Host ""
        $choice = Read-Host "Select an option [1-4] (default: 4)"
        if ([string]::IsNullOrWhiteSpace($choice)) { $choice = '4' }
        Write-Log -Message ("User selected main menu option {0}" -f $choice) -Level 'Action' -MenuOption $choice -LogFile $logFile
        switch ($choice) {
            '1' {
                try {
                    Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile
                } catch {
                    Write-Log -Message ("Error in Deployment Script Configuration Management menu: {0}" -f $_) -Level 'Error' -LogFile $logFile
                    Write-Host "An error occurred in the Deployment Script Configuration Management menu: $($_.Exception.Message)" -ForegroundColor Red
                    Write-Host 'Press Enter to return to the main menu.' -ForegroundColor Yellow
                    Read-Host
                }
            }
            '2' {
                try {
                    Get-LogsMenu -LogDirectory $LogDirectory -LogFile $logFile
                } catch {
                    Write-Log -Message ("Error in Get Logs menu: {0}" -f $_) -Level 'Error' -LogFile $logFile
                    Write-Host "An error occurred in the Get Logs menu: $($_.Exception.Message)" -ForegroundColor Red
                    Write-Host 'Press Enter to return to the main menu.' -ForegroundColor Yellow
                    Read-Host
                }
            }
            '3' {
                try {
                    Show-HelpMenu -logFile $logFile
                } catch {
                    Write-Log -Message ("Error in Help menu: {0}" -f $_) -Level 'Error' -LogFile $logFile
                    Write-Host "An error occurred in the Help menu: $($_.Exception.Message)" -ForegroundColor Red
                    Write-Host 'Press Enter to return to the main menu.' -ForegroundColor Yellow
                    Read-Host
                }
            }
            '4' { Write-Log -Message 'User exited from main menu.' -Level 'Info' -LogFile $logFile; Write-Log -Message 'Exiting...' -Level 'Info' -LogFile $logFile; Stop-Transcript; exit }
            default { Write-Log -Message ("Invalid main menu selection: {0}" -f $choice) -Level 'Warning' -LogFile $logFile; Write-Log -Message 'Invalid selection. Please choose 1-4.' -Level 'Warning' -LogFile $logFile }
        }
        if ($choice -eq '4') { break }
    }
}
