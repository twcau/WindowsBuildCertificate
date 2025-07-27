<#!
.SYNOPSIS
    CLI logic for editing the default configuration for all new deployment scripts.
.DESCRIPTION
    Provides a text-based, accessible menu for toggling, saving, and getting help on configuration options, using the master and user config JSON files.
.FILECREATED    2025-07-27
.FILELASTUPDATED 2025-07-27
.AUTHOR         Michael Harris
.COPYRIGHT      Copyright (c) 2025, Michael Harris, All rights reserved.
.DOCUMENTATION  https://twcau.github.io/WindowsBuildCertificate/
.NOTES          EN-AU spelling and accessible output throughout.
#>

function Edit-DefaultDeploymentConfig {
    <#
    .SYNOPSIS
        Allows the user to edit the default configuration for all new deployment scripts.
    .DESCRIPTION
        Loads the master and user config JSON, presents an accessible menu to toggle options, view help, save, reload, or exit. All actions are logged.
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

    $masterPath = Join-Path $PSScriptRoot '../../configuration/master/master-config-options.json'
    $userConfigPath = Get-ChildItem -Path (Join-Path $PSScriptRoot '../../configuration/user') -Filter 'default-*.scriptconfig.json' | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | ForEach-Object { $_.FullName }
    if (-not $userConfigPath) {
        Write-Log -Message 'No user config found. Creating new default config.' -Level 'Warning' -LogFile $logFile
        $userConfigPath = Join-Path $PSScriptRoot '../../configuration/user/default-' + (Get-Date -Format 'yyyyMMdd-HHmm') + '.scriptconfig.json'
        Copy-Item $masterPath $userConfigPath
    }
    $master = Get-Content $masterPath | ConvertFrom-Json
    $user = Get-Content $userConfigPath | ConvertFrom-Json
    $optionStates = @{}
    foreach ($opt in $user.Options) { $optionStates[$opt.ID] = $opt.State }
    $options = $master.Options
    $unsaved = $false
    while ($true) {
        Clear-Host
        Write-Host ("=== Default Configuration Editor ===") -ForegroundColor Cyan
        Write-Host ("Config: {0}" -f $user.ConfigName)
        Write-Host ("Description: {0}" -f $user.Description)
        Write-Host ""
        Write-Host "Pre-Deployment Options:"
        $pre = $options | Where-Object { $_.PreOrPost -eq 'Pre' }
        foreach ($opt in $pre) {
            $state = if ($optionStates[$opt.ID]) { '[X]' } else { '[ ]' }
            Write-Host ("[{0}] {1} {2}" -f $opt.ID, $state, $opt.Name)
        }
        Write-Host ""
        Write-Host "Post-Deployment Options:"
        $post = $options | Where-Object { $_.PreOrPost -eq 'Post' }
        foreach ($opt in $post) {
            $state = if ($optionStates[$opt.ID]) { '[X]' } else { '[ ]' }
            Write-Host ("[{0}] {1} {2}" -f $opt.ID, $state, $opt.Name)
        }
        Write-Host ""
        Write-Host "Type a number to toggle, '?N' for help, 'A' to select all, 'N' to select none, 'S' to save, 'R' to reload, 'Q' to quit."
        $userInput = Read-Host "Selection"
        if ($userInput -match '^[0-9]+$') {
            $id = [int]$userInput
            if ($options | Where-Object { $_.ID -eq $id }) {
                $optionStates[$id] = -not $optionStates[$id]
                $unsaved = $true
                Write-Log -Message ("Toggled option {0} to {1}" -f $id, $optionStates[$id]) -Level 'Action' -LogFile $logFile
            }
        }
        elseif ($userInput -match '^\?([0-9]+)$') {
            $id = [int]$Matches[1]
            $opt = $options | Where-Object { $_.ID -eq $id }
            if ($opt) {
                Write-Host ("Help for {0}: {1}" -f $opt.Name, $opt.HelpDescription) -ForegroundColor Magenta
                Write-Log -Message ("Displayed help for option {0}" -f $id) -Level 'Info' -LogFile $logFile
                Read-Host "Press Enter to continue"
            }
        }
        elseif ($userInput -eq 'A') {
            foreach ($id in $options.ID) { $optionStates[$id] = $true }
            $unsaved = $true
            Write-Log -Message 'Selected all options.' -Level 'Action' -LogFile $logFile
        }
        elseif ($userInput -eq 'N') {
            foreach ($id in $options.ID) { $optionStates[$id] = $false }
            $unsaved = $true
            Write-Log -Message 'Deselected all options.' -Level 'Action' -LogFile $logFile
        }
        elseif ($userInput -eq 'S') {
            $user.Options = @()
            foreach ($id in $options.ID) {
                $user.Options += @{ ID = $id; State = $optionStates[$id] }
            }
            $user.LastModified = (Get-Date -Format 'yyyy-MM-dd')
            $user.ModifiedBy = $env:USERNAME
            $user.ChangeHistory += ("{0}: Saved config changes." -f (Get-Date -Format 'yyyy-MM-dd HH:mm'))
            $user | ConvertTo-Json -Depth 5 | Set-Content $userConfigPath
            $unsaved = $false
            Write-Log -Message 'Saved user config.' -Level 'Info' -LogFile $logFile
            Write-Host "Configuration saved." -ForegroundColor Green
            Start-Sleep -Seconds 1
        }
        elseif ($userInput -eq 'R') {
            $user = Get-Content $userConfigPath | ConvertFrom-Json
            foreach ($opt in $user.Options) { $optionStates[$opt.ID] = $opt.State }
            $unsaved = $false
            Write-Log -Message 'Reloaded user config.' -Level 'Info' -LogFile $logFile
        }
        elseif ($userInput -eq 'Q') {
            if ($unsaved) {
                Write-Host "You have unsaved changes. Save before exiting? (Y/N)" -ForegroundColor Yellow
                $ans = Read-Host "Save changes? (Y/N)"
                if ($ans -match '^[Yy]$') {
                    $user.Options = @()
                    foreach ($id in $options.ID) {
                        $user.Options += @{ ID = $id; State = $optionStates[$id] }
                    }
                    $user.LastModified = (Get-Date -Format 'yyyy-MM-dd')
                    $user.ModifiedBy = $env:USERNAME
                    $user.ChangeHistory += ("{0}: Saved config changes on exit." -f (Get-Date -Format 'yyyy-MM-dd HH:mm'))
                    $user | ConvertTo-Json -Depth 5 | Set-Content $userConfigPath
                    Write-Log -Message 'Saved user config on exit.' -Level 'Info' -LogFile $logFile
                }
                else {
                    Write-Log -Message 'Exited without saving changes.' -Level 'Warning' -LogFile $logFile
                }
            }
            break
        }
    }
}
