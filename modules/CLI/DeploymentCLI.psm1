<#!
.SYNOPSIS
    Provides deployment script configuration management CLI and menu for WindowsBuildCertificate.
.DESCRIPTION
    Contains all logic for creating, editing, exporting, archiving, and restoring deployment script configurations.
    Designed for robust import and use from the main entry script.
    EN-AU spelling and accessible output throughout.
.FILECREATED    2025-07-26
.FILELASTUPDATED 2025-07-26
.AUTHOR         Michael Harris
.COPYRIGHT      Copyright (c) 2025, Michael Harris, All rights reserved.
.DOCUMENTATION  https://twcau.github.io/WindowsBuildCertificate/
.NOTES          EN-AU spelling and accessible output throughout.
#>

function Show-DeploymentConfigMenu {
    <#
    .SYNOPSIS
        Displays the deployment script configuration management menu and handles user selection.
    .DESCRIPTION
        Presents options to create, edit, export, archive, restore, or set default deployment configurations. Handles user input and calls the appropriate function.
    .PARAMETER ConfigDirectory
        The directory where deployment configurations are stored.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param(
        [string]$ConfigDirectory,
        [string]$logFile
    )
    Clear-Host
    Write-Host ("=== {0}: Deployment Script Configuration Management ===" -f $Global:MenuTitle) -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Create new deployment script configuration"
    Write-Host "2. Edit existing deployment script configuration"
    Write-Host "3. Export deployment scripts from an existing configuration"
    Write-Host "4. Archive deployment configurations not used in the last 90 days"
    Write-Host "5. Restore an archived configuration"
    Write-Host "6. Create/Update default configuration for all new deployment scripts"
    Write-Host "7. Return to main menu"
    Write-Host ""
    $choice = Read-Host "Select an option [1-7] (default: 7)"
    if ([string]::IsNullOrWhiteSpace($choice)) { $choice = '7' }
    Write-Log -Message ("User selected deployment menu option: {0}" -f $choice) -Level 'Action' -MenuOption $choice -LogFile $logFile
    switch ($choice) {
        '1' { try { New-DeploymentConfig -ConfigDirectory $ConfigDirectory -logFile $logFile } catch { Write-Log -Message ("Error in New-DeploymentConfig: {0}" -f $_) -Level 'Error' -LogFile $logFile; Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red; Write-Host 'Press Enter to return to the deployment menu.' -ForegroundColor Yellow; Read-Host; Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile; return } }
        '2' { try { Edit-DeploymentConfig -ConfigDirectory $ConfigDirectory -logFile $logFile } catch { Write-Log -Message ("Error in Edit-DeploymentConfig: {0}" -f $_) -Level 'Error' -LogFile $logFile; Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red; Write-Host 'Press Enter to return to the deployment menu.' -ForegroundColor Yellow; Read-Host; Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile; return } }
        '3' { try { Export-DeploymentScripts -ConfigDirectory $ConfigDirectory -logFile $logFile } catch { Write-Log -Message ("Error in Export-DeploymentScripts: {0}" -f $_) -Level 'Error' -LogFile $logFile; Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red; Write-Host 'Press Enter to return to the deployment menu.' -ForegroundColor Yellow; Read-Host; Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile; return } }
        '4' { try { Remove-OldDeploymentConfigs -ConfigDirectory $ConfigDirectory -logFile $logFile } catch { Write-Log -Message ("Error in Remove-OldDeploymentConfigs: {0}" -f $_) -Level 'Error' -LogFile $logFile; Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red; Write-Host 'Press Enter to return to the deployment menu.' -ForegroundColor Yellow; Read-Host; Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile; return } }
        '5' { try { Restore-ArchivedDeploymentConfig -ConfigDirectory $ConfigDirectory -logFile $logFile } catch { Write-Log -Message ("Error in Restore-ArchivedDeploymentConfig: {0}" -f $_) -Level 'Error' -LogFile $logFile; Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red; Write-Host 'Press Enter to return to the deployment menu.' -ForegroundColor Yellow; Read-Host; Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile; return } }
        '6' { try { Edit-DefaultDeploymentConfig -ConfigDirectory $ConfigDirectory -logFile $logFile } catch { Write-Log -Message ("Error in Edit-DefaultDeploymentConfig: {0}" -f $_) -Level 'Error' -LogFile $logFile; Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red; Write-Host 'Press Enter to return to the deployment menu.' -ForegroundColor Yellow; Read-Host; Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile; return } }
        '7' { Write-Log -Message 'User exited deployment menu.' -Level 'Info' -LogFile $logFile; return }
        default { Write-Log -Message ("Invalid deployment menu selection: {0}" -f $choice) -Level 'Warning' -LogFile $logFile; Write-Log -Message 'Invalid selection. Please choose 1-7.' -Level 'Warning' -LogFile $logFile; Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile }
    }
}

function New-DeploymentConfig {
    <#
    .SYNOPSIS
        Stub for creating a new deployment script configuration.
    .DESCRIPTION
        Placeholder for future implementation. Logs the action and prompts the user to return to the menu.
    .PARAMETER ConfigDirectory
        The directory where deployment configurations are stored.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        New-DeploymentConfig -ConfigDirectory $ConfigDirectory -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param([string]$ConfigDirectory, [string]$logFile)
    Write-Log -Message '[Stub] Create new deployment script configuration called.' -Level 'Info' -LogFile $logFile
    Write-Log -Message '[Stub] Create new deployment script configuration logic goes here.' -Level 'Error' -LogFile $logFile
    Write-Log -Message 'Yet to be created' -Level 'Warning' -LogFile $logFile
    Write-Log -Message 'Press enter to return to main menu' -Level 'Info' -LogFile $logFile
    Read-Host
    Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile
}
function Edit-DeploymentConfig {
    <#
    .SYNOPSIS
        Entry point for editing an existing deployment script configuration.
    .DESCRIPTION
        Handles file locking, invokes category selection, and manages the edit workflow.
    .PARAMETER ConfigDirectory
        The directory where deployment configurations are stored.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        Edit-DeploymentConfig -ConfigDirectory $ConfigDirectory -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param([string]$ConfigDirectory, [string]$logFile)
    Write-Log -Message '[Stub] Edit existing deployment script configuration called.' -Level 'Info' -LogFile $logFile
    Write-Host '[Stub] Edit existing deployment script configuration logic goes here.' -ForegroundColor Yellow
    Write-Host 'Yet to be created' -ForegroundColor Red
    Write-Host 'Press Enter to return to the previous menu' -ForegroundColor Yellow
    Read-Host
    Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile
}

function Show-EditConfigMenu {
    <#
    .SYNOPSIS
        Shows the main edit workflow menu for a selected config.
    .DESCRIPTION
        Allows category selection, dry-run, change history, and save/exit/discard.
    .PARAMETER ConfigDirectory
        The directory where deployment configurations are stored.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        Show-EditConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param([string]$ConfigDirectory, [string]$logFile)
    while ($true) {
        Clear-Host
        Write-Host '=== Edit Deployment Script Configuration ===' -ForegroundColor Cyan
        Write-Host 'a. Select Category (e.g., Intune/MDM, AD, etc.)'
        Write-Host 'b. Validate/Preview Configuration (dry-run, show issues, show order of operations, preview build certificate)'
        Write-Host 'c. Change History (view, undo, redo; by date and user)'
        Write-Host 'd. Save/Exit/Discard Changes'
        Write-Host 'e. Return to previous menu'
        $choice = Read-Host 'Select an option [a-e] (default: e)'
        if ([string]::IsNullOrWhiteSpace($choice)) { $choice = 'e' }
        switch ($choice.ToLower()) {
            'a' { Show-SelectCategoryMenu -ConfigDirectory $ConfigDirectory -logFile $logFile }
            'b' {
                Write-Log -Message '[Stub] Dry-run/validation logic called.' -Level 'Info' -LogFile $logFile
                Write-Host '[Stub] Dry-run/validation logic goes here.' -ForegroundColor Yellow
                Write-Host 'Yet to be created' -ForegroundColor Red
                Write-Host 'Press Enter to return to the previous menu' -ForegroundColor Yellow
                Read-Host
                return
            }
            'c' {
                Write-Log -Message '[Stub] Change history logic called.' -Level 'Info' -LogFile $logFile
                Write-Host '[Stub] Change history logic goes here.' -ForegroundColor Yellow
                Write-Host 'Yet to be created' -ForegroundColor Red
                Write-Host 'Press Enter to return to the previous menu' -ForegroundColor Yellow
                Read-Host
                return
            }
            'd' {
                Write-Log -Message '[Stub] Save/Exit/Discard logic called.' -Level 'Info' -LogFile $logFile
                Write-Host '[Stub] Save/Exit/Discard logic goes here.' -ForegroundColor Yellow
                Write-Host 'Yet to be created' -ForegroundColor Red
                Write-Host 'Press Enter to return to the previous menu' -ForegroundColor Yellow
                Read-Host
                return
            }
            'e' { Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile; return }
            default { Write-Host 'Invalid selection. Please choose a-e.' -ForegroundColor Red; Read-Host 'Press Enter to continue' }
        }
    }
}

function Show-SelectCategoryMenu {
    <#
    .SYNOPSIS
        Shows the category selection menu for config editing.
    .DESCRIPTION
        Lets the user pick a config category to edit (e.g., Intune/MDM, AD, etc.).
    .PARAMETER ConfigDirectory
        The directory where deployment configurations are stored.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        Show-SelectCategoryMenu -ConfigDirectory $ConfigDirectory -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param([string]$ConfigDirectory, [string]$logFile)
    $categories = @('Intune/MDM', 'Active Directory', 'Device Configuration', 'Device Security', 'Applications', 'Cloud Services', 'Windows Update', 'Network & Connectivity', 'Miscellaneous')
    while ($true) {
        Clear-Host
        Write-Host '=== Select Configuration Category ===' -ForegroundColor Cyan
        for ($i = 0; $i -lt $categories.Count; $i++) {
            Write-Host ("{0}. {1}" -f ($i + 1), $categories[$i])
        }
        Write-Host ("{0}. Return to previous menu" -f ($categories.Count + 1))
        $choice = Read-Host ("Select a category [1-{0}] (default: {0})" -f ($categories.Count + 1))
        if ([string]::IsNullOrWhiteSpace($choice)) { $choice = ($categories.Count + 1).ToString() }
        if ($choice -match '^[0-9]+$' -and [int]$choice -ge 1 -and [int]$choice -le ($categories.Count + 1)) {
            if ([int]$choice -eq ($categories.Count + 1)) { Show-EditConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile; return }
            Show-OptionListMenu -Category $categories[([int]$choice - 1)] -ConfigDirectory $ConfigDirectory -logFile $logFile
        }
        else {
            Write-Host 'Invalid selection.' -ForegroundColor Red
            Read-Host 'Press Enter to continue'
        }
    }
}

function Show-OptionListMenu {
    <#
    .SYNOPSIS
        Shows the list of options for a selected category.
    .DESCRIPTION
        Lets the user view and edit options in the chosen category.
    .PARAMETER Category
        The selected configuration category.
    .PARAMETER ConfigDirectory
        The directory where deployment configurations are stored.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        Show-OptionListMenu -Category $Category -ConfigDirectory $ConfigDirectory -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param([string]$Category, [string]$ConfigDirectory, [string]$logFile)
    Write-Log -Message ("[Stub] Option list/edit menu for category: {0}" -f $Category) -Level 'Info' -LogFile $logFile
    Write-Host ("[Stub] Option list/edit menu for category: {0}" -f $Category) -ForegroundColor Yellow
    Write-Host '[Stub] This will show all options in the category, allow edit, bulk actions, and help.'
    Write-Host 'Yet to be created' -ForegroundColor Red
    Write-Host 'Press Enter to return to category menu' -ForegroundColor Yellow
    Read-Host
    Show-SelectCategoryMenu -ConfigDirectory $ConfigDirectory -logFile $logFile
}

function Export-DeploymentScripts {
    <#
    .SYNOPSIS
        Stub for exporting deployment scripts from an existing configuration.
    .DESCRIPTION
        Placeholder for future implementation. Logs the action and prompts the user to return to the menu.
    .PARAMETER ConfigDirectory
        The directory where deployment configurations are stored.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        Export-DeploymentScripts -ConfigDirectory $ConfigDirectory -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param([string]$ConfigDirectory, [string]$logFile)
    Write-Log -Message '[Stub] Export deployment scripts called.' -Level 'Info' -LogFile $logFile
    Write-Log -Message '[Stub] Export deployment scripts logic goes here.' -Level 'Error' -LogFile $logFile
    Write-Log -Message 'Yet to be created' -Level 'Warning' -LogFile $logFile
    Write-Log -Message 'Press enter to return to main menu' -Level 'Info' -LogFile $logFile
    Read-Host
    Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile
}
function Remove-OldDeploymentConfigs {
    <#
    .SYNOPSIS
        Stub for archiving deployment configurations not used in the last 90 days.
    .DESCRIPTION
        Placeholder for future implementation. Logs the action and prompts the user to return to the menu.
    .PARAMETER ConfigDirectory
        The directory where deployment configurations are stored.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        Remove-OldDeploymentConfigs -ConfigDirectory $ConfigDirectory -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param([string]$ConfigDirectory, [string]$logFile)
    Write-Log -Message '[Stub] Remove old deployment configurations not used in the last 90 days called.' -Level 'Info' -LogFile $logFile
    Write-Log -Message '[Stub] Remove old deployment configurations logic goes here.' -Level 'Error' -LogFile $logFile
    Write-Log -Message 'Yet to be created' -Level 'Warning' -LogFile $logFile
    Write-Log -Message 'Press enter to return to main menu' -Level 'Info' -LogFile $logFile
    Read-Host
    Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile
}
function Restore-ArchivedDeploymentConfig {
    <#
    .SYNOPSIS
        Stub for restoring an archived deployment configuration.
    .DESCRIPTION
        Placeholder for future implementation. Prompts the user to return to the menu.
    .PARAMETER ConfigDirectory
        The directory where deployment configurations are stored.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        Restore-ArchivedDeploymentConfig -ConfigDirectory $ConfigDirectory -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param([string]$ConfigDirectory, [string]$logFile)
    Write-Host ""
    Write-Host "[Stub] Retrieve an archived configuration logic goes here." -ForegroundColor Red
    Write-Host "Yet to be created" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press enter to return to main menu" -ForegroundColor Yellow
    Read-Host
    Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile
}
function Edit-DefaultDeploymentConfig {
    <#
    .SYNOPSIS
        Loads and invokes the modularised default configuration editor.
    .DESCRIPTION
        Imports the DefaultConfigCLI module and calls Edit-DefaultDeploymentConfig, passing through parameters. All actions are logged.
    .PARAMETER ConfigDirectory
        The directory where user configuration files are stored.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        Edit-DefaultDeploymentConfig -ConfigDirectory $ConfigDirectory -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param([string]$ConfigDirectory, [string]$logFile)
    $modulePath = Join-Path $PSScriptRoot '../CLI/DefaultConfigCLI.psm1'
    try {
        if (-not (Get-Module -ListAvailable | Where-Object { $_.Path -eq $modulePath })) {
            Import-Module $modulePath -Force
            Write-Log -Message ("Imported module: {0}" -f $modulePath) -Level 'Info' -LogFile $logFile
        }
        Write-Log -Message 'Invoking modularised Edit-DefaultDeploymentConfig.' -Level 'Action' -LogFile $logFile
        Import-Module $modulePath -Force
        Edit-DefaultDeploymentConfig -ConfigDirectory $ConfigDirectory -logFile $logFile
    }
    catch {
        Write-Log -Message ("Error in Edit-DefaultDeploymentConfig wrapper: {0}" -f $_) -Level 'Error' -LogFile $logFile
        Write-Host "A critical error occurred in the configuration editor: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host "Press Enter to return to the deployment menu"
    }
    Show-DeploymentConfigMenu -ConfigDirectory $ConfigDirectory -logFile $logFile
}
