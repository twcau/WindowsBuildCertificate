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
        Loads the master and user config JSON, presents an accessible menu to toggle options, view help, save, reload, or exit. All actions are logged. All errors are logged and require user acknowledgement before returning.
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

    # Helper: Recalculate changed state for all options
    function Update-ChangedState {
        foreach ($opt in $options) {
            $opt.Changed = ($opt.State -ne $opt.OriginalState)
        }
    }

    try {
        Write-Host "Loading configuration, please wait..." -ForegroundColor Yellow
        $masterPath = Join-Path $PSScriptRoot '../../configuration/master/master-config-options.json'
        if (-not (Test-Path $masterPath)) {
            Write-Log -Message "Master config file not found: $masterPath" -Level 'Error' -LogFile $logFile
            Write-Host "Error: Master config file not found." -ForegroundColor Red
            Read-Host "Press Enter to return to the menu"
            return
        }
        $userConfigPath = Get-ChildItem -Path (Join-Path $PSScriptRoot '../../configuration/user') -Filter 'default-*.scriptconfig.json' | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | ForEach-Object { $_.FullName }
        if (-not $userConfigPath) {
            Write-Log -Message 'No user config found. Creating new default config.' -Level 'Warning' -LogFile $logFile
            $userConfigPath = Join-Path $PSScriptRoot '../../configuration/user/default-' + (Get-Date -Format 'yyyyMMdd-HHmm') + '.scriptconfig.json'
            Copy-Item $masterPath $userConfigPath
        }
        if (-not (Test-Path $userConfigPath)) {
            Write-Log -Message "User config file not found: $userConfigPath" -Level 'Error' -LogFile $logFile
            Write-Host "Error: User config file not found." -ForegroundColor Red
            Read-Host "Press Enter to return to the menu"
            return
        }
        $master = Get-Content $masterPath | ConvertFrom-Json
        $user = Get-Content $userConfigPath | ConvertFrom-Json
    }
    catch {
        Write-Log -Message ("Exception loading config files: {0}" -f $_) -Level 'Error' -LogFile $logFile
        Write-Host "An error occurred loading configuration files: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host "Press Enter to return to the menu"
        return
    }
    # Build $options with all required properties, including Category
    $options = @()
    foreach ($m in $master.Options) {
        $userOpt = $user.Options | Where-Object { $_.ID -eq $m.ID }
        $state = if ($userOpt) { $userOpt.State } else { $m.State }
        $options += [PSCustomObject]@{
            ID              = $m.ID
            Name            = $m.Name
            PreOrPost       = $m.PreOrPost
            HelpDescription = $m.HelpDescription
            State           = $state
            OriginalState   = $state
            Category        = $m.Category
            Changed         = $false
        }
    }
    # Assign unique tab keys
    $tabLabels = @{ 'Pre' = 'Pre-Deployment'; 'Post' = 'Post-Deployment'; 'User' = 'User Options' }
    $tabKeys = @{ 'Pre' = 'P'; 'Post' = 'T'; 'User' = 'U' }
    # Dynamically build availableTabs based on options present
    $availableTabs = @()
    if ($options | Where-Object { $_.PreOrPost -eq 'Pre' }) { $availableTabs += 'Pre' }
    if ($options | Where-Object { $_.PreOrPost -eq 'Post' }) { $availableTabs += 'Post' }
    if ($options | Where-Object { $_.PreOrPost -eq 'User' }) { $availableTabs += 'User' }
    if (-not $availableTabs) { $availableTabs = @('Pre') } # fallback
    $activeTab = $availableTabs[0]
    function Get-TabOptions($tab) {
        if ($tab -eq 'Pre') { return $options | Where-Object { $_.PreOrPost -eq 'Pre' } }
        if ($tab -eq 'Post') { return $options | Where-Object { $_.PreOrPost -eq 'Post' } }
        if ($tab -eq 'User') { return $options | Where-Object { $_.PreOrPost -eq 'User' } }
        return @()
    }
    $page = 1
    $lastTab = $activeTab
    while ($true) {
        try {
            # Always recalculate changed state before drawing menu
            Update-ChangedState
            # Get options for active tab, group by category, sort
            $tabOptions = Get-TabOptions $activeTab
            if ($activeTab -ne $lastTab) { $page = 1 }
            $lastTab = $activeTab
            $categories = $tabOptions | Select-Object -ExpandProperty Category -Unique | Sort-Object
            $grouped = @()
            foreach ($cat in $categories) {
                $catOpts = $tabOptions | Where-Object { $_.Category -eq $cat } | Sort-Object Name
                $grouped += @{ Category = $cat; Options = $catOpts }
            }
            # Sequential numbering for options in this tab
            $optionMap = @{}
            $displayRows = @()
            $displayIndex = 1
            foreach ($group in $grouped) {
                $catHeader = ("-- {0} --" -f $group.Category)
                $displayRows += @{ IsHeader = $true; Text = $catHeader; Category = $group.Category }
                foreach ($opt in $group.Options) {
                    $state = if ($opt.State) { '[X]' } else { '[ ]' }
                    $changed = ($opt.State -ne $opt.OriginalState)
                    $asterisk = if ($changed) { '*' } else { ' ' }
                    $line = ('{0,2}. {1} {2} {3}' -f $displayIndex, $state, $asterisk, $opt.Name)
                    $displayRows += @{ IsHeader = $false; Text = $line; Changed = $changed; Option = $opt; DisplayNum = $displayIndex }
                    $optionMap[$displayIndex] = $opt
                    $displayIndex++
                }
                # Add a blank line after each category for clarity
                $displayRows += @{ IsHeader = $false; Text = ''; Changed = $false }
            }
            # Remove category headers with no options
            $displayRows = $displayRows | Where-Object { $_.IsHeader -eq $false -or ($_.IsHeader -and ($grouped | Where-Object { $_.Category -eq $_.Category }).Options.Count -gt 0) }
            # Remove trailing blank line
            if ($displayRows.Count -gt 0 -and $displayRows[-1].Text -eq '') { $displayRows = $displayRows[0..($displayRows.Count - 2)] }
            # --- Paging and column/width detection ---
            $hostHeight = $Host.UI.RawUI.WindowSize.Height
            $hostWidth = $Host.UI.RawUI.WindowSize.Width
            $maxRows = [Math]::Max(6, $hostHeight - 10)
            # --- Category-aware paging: never split a category across pages ---
            $catBlocks = @(); $block = @(); $rowCount = 0; $blocks = @()
            foreach ($row in $displayRows) {
                if ($row.IsHeader -and $block.Count -gt 0) { $catBlocks += , $block; $block = @() }
                $block += $row
            }
            if ($block.Count -gt 0) { $catBlocks += , $block }
            # Build pages: each page is a set of catBlocks that fit in maxRows
            $pages = @(); $pageBlock = @(); $rowsInPage = 0
            foreach ($cat in $catBlocks) {
                if ($rowsInPage + $cat.Count -gt $maxRows -and $pageBlock.Count -gt 0) {
                    $pages += , $pageBlock; $pageBlock = @(); $rowsInPage = 0
                }
                $pageBlock += $cat; $rowsInPage += $cat.Count
            }
            if ($pageBlock.Count -gt 0) { $pages += , $pageBlock }
            $totalPages = $pages.Count
            if ($page -gt $totalPages) { $page = $totalPages }
            $showPaging = $totalPages -gt 1
            $currentRows = $pages[$page - 1]
            # Columnar layout: split by category block, not by row count
            $colCount = 1
            $colWidth = [Math]::Min(45, [Math]::Floor($hostWidth / 2) - 2)
            if ($currentRows.Count -gt $maxRows) { $colCount = 2 }
            if ($colCount -eq 2 -and $hostWidth -lt 90) { $colCount = 1 }
            $columns = @()
            if ($colCount -eq 1) {
                $columns += , $currentRows
            }
            else {
                $catBlocksPage = @(); $block = @()
                foreach ($row in $currentRows) {
                    if ($row.IsHeader -and $block.Count -gt 0) { $catBlocksPage += , $block; $block = @() }
                    $block += $row
                }
                if ($block.Count -gt 0) { $catBlocksPage += , $block }
                $mid = [Math]::Ceiling($catBlocksPage.Count / 2)
                $columns += , (@()); $columns += , (@())
                for ($i = 0; $i -lt $catBlocksPage.Count; $i++) {
                    if ($i -lt $mid) { $columns[0] += $catBlocksPage[$i] } else { $columns[1] += $catBlocksPage[$i] }
                }
            }
            Clear-Host
            # Print menu header and tab bar always
            Write-Host ("===  {0}: Default Configuration Editor ===" -f $Global:MenuTitle) -ForegroundColor Cyan
            $tabBar = ''
            foreach ($tab in $availableTabs) {
                $label = $tabLabels[$tab]
                $key = $tabKeys[$tab]
                if ($tab -eq $activeTab) {
                    $tabBar += ("[{0}] {1}" -f $key, $label).ToUpper()
                    if ($showPaging) { $tabBar += ("   (Page {0}/{1})" -f $page, $totalPages) }
                }
                else {
                    $tabBar += ("[{0}] {1}" -f $key, $label)
                }
                if ($tab -ne $availableTabs[-1]) { $tabBar += " | " }
            }
            Write-Host $tabBar -ForegroundColor Yellow
            Write-Host ""
            # Print columns, line by line, with wrapping/truncation, or fallback if empty
            if (-not $currentRows -or $currentRows.Count -eq 0) {
                Write-Host "No options available for this tab." -ForegroundColor Red
                [Console]::ResetColor()
            }
            else {
                $rowsPerCol = ($columns | ForEach-Object { $_.Count } | Measure-Object -Maximum).Maximum
                for ($i = 0; $i -lt $rowsPerCol; $i++) {
                    $line = ''
                    for ($c = 0; $c -lt $colCount; $c++) {
                        if ($columns.Count -gt $c -and $columns[$c] -and $columns[$c].Count -gt $i -and $columns[$c][$i]) {
                            $row = $columns[$c][$i]
                            $text = $row.Text
                            if (-not $row.IsHeader -and $text.Length -gt $colWidth) {
                                $text = $text.Substring(0, $colWidth - 3) + '...'
                            }
                            $line += ("{0,-$colWidth}" -f $text)
                        }
                        else {
                            $line += ("{0,-$colWidth}" -f '')
                        }
                    }
                    # Only colour the toggled/changed option text, not the whole line
                    if ($colCount -eq 1) {
                        if ($currentRows.Count -gt $i -and $currentRows[$i] -and $currentRows[$i].IsHeader) {
                            Write-Host $line -ForegroundColor Cyan
                        }
                        elseif ($currentRows.Count -gt $i -and $currentRows[$i] -and $currentRows[$i].Changed) {
                            Write-Host $line -ForegroundColor Red
                        }
                        else {
                            Write-Host $line
                        }
                    }
                    else {
                        $col0 = ($columns.Count -gt 0 -and $columns[0].Count -gt $i) ? $columns[0][$i] : $null
                        $col1 = ($columns.Count -gt 1 -and $columns[1].Count -gt $i) ? $columns[1][$i] : $null
                        $out = ''
                        if ($col0) {
                            $text0 = $col0.Text
                            if (-not $col0.IsHeader -and $text0.Length -gt $colWidth) { $text0 = $text0.Substring(0, $colWidth - 3) + '...' }
                            $out += ("{0,-$colWidth}" -f $text0)
                        }
                        else { $out += ("{0,-$colWidth}" -f '') }
                        if ($col1) {
                            $text1 = $col1.Text
                            if (-not $col1.IsHeader -and $text1.Length -gt $colWidth) { $text1 = $text1.Substring(0, $colWidth - 3) + '...' }
                            $out += ("{0,-$colWidth}" -f $text1)
                        }
                        else { $out += ("{0,-$colWidth}" -f '') }
                        if ($col0 -and $col0.IsHeader) { Write-Host $out -ForegroundColor Cyan }
                        elseif ($col0 -and $col0.Changed) { Write-Host $out -ForegroundColor Red }
                        elseif ($col1 -and $col1.Changed) { Write-Host $out -ForegroundColor Red }
                        else { Write-Host $out }
                    }
                }
            }
            Write-Host ""
            Write-Host "Legend: * = changed since last save/load" -ForegroundColor Red
            # Tab key legend, always explicit, and paging keys
            $tabLegend = $availableTabs | ForEach-Object { '[{0}]={1}' -f $tabKeys[$_], $tabLabels[$_] } | Join-String ' | '
            $pagingLegend = $showPaging ? 'F=Next page, B=Previous page.' : ''
            Write-Host ("Type a number to toggle, '?N' for help, 'A' to select all, 'N' to select none, 'S' to save, 'R' to reload, 'Q' to quit.")
            Write-Host ("Use tab keys: {0} to switch tabs. {1}" -f $tabLegend, $pagingLegend)
            $userInput = $null
            try { $userInput = Read-Host "Selection" } catch { continue }
            if ($null -eq $userInput) { continue }
            # Paging controls (F=Forward, B=Back, case-insensitive)
            if ($showPaging -and $userInput.ToUpper() -eq 'F' -and $page -lt $totalPages) { $page++; continue }
            if ($showPaging -and $userInput.ToUpper() -eq 'B' -and $page -gt 1) { $page--; continue }
            # Tab switching
            if ($tabKeys.Values -contains $userInput.ToUpper() -and $availableTabs -contains ($tabKeys.GetEnumerator() | Where-Object { $_.Value -eq $userInput.ToUpper() } | Select-Object -ExpandProperty Key)) {
                $activeTab = ($tabKeys.GetEnumerator() | Where-Object { $_.Value -eq $userInput.ToUpper() } | Select-Object -ExpandProperty Key)
                $page = 1
                continue
            }
            # Option toggling/help by display number (support comma-separated for toggling)
            if ($userInput -match '^[0-9]+(,[0-9]+)*$') {
                $nums = $userInput -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^[0-9]+$' }
                $visibleOptionMap = @{}
                $visibleIndex = 1
                foreach ($row in $currentRows) {
                    if (-not $row.IsHeader -and $row.Option) {
                        $visibleOptionMap[$visibleIndex] = $row.Option
                        $visibleIndex++
                    }
                }
                $toggled = @()
                foreach ($n in $nums) {
                    $num = [int]$n
                    if ($visibleOptionMap.ContainsKey($num)) {
                        $opt = $visibleOptionMap[$num]
                        $opt.State = -not $opt.State
                        $toggled += $opt.Name
                    }
                }
                Update-ChangedState
                if ($toggled.Count -gt 0) {
                    Write-Log -Message ("Toggled options: {0}" -f ($toggled -join ', ')) -Level 'Action' -LogFile $logFile
                    Write-Host ("Toggled: {0}" -f ($toggled -join ', ')) -ForegroundColor Cyan
                    Read-Host "Press Enter to continue"
                    continue
                }
                continue
            }
            # Help for single option
            elseif ($userInput -match '^\?([0-9]+)$') {
                $num = [int]$Matches[1]
                $visibleOptionMap = @{}
                $visibleIndex = 1
                foreach ($row in $currentRows) {
                    if (-not $row.IsHeader -and $row.Option) {
                        $visibleOptionMap[$visibleIndex] = $row.Option
                        $visibleIndex++
                    }
                }
                if ($visibleOptionMap.ContainsKey($num)) {
                    $opt = $visibleOptionMap[$num]
                    Write-Host ("Help for {0}: {1}" -f $opt.Name, $opt.HelpDescription) -ForegroundColor Magenta
                    Write-Log -Message ("Displayed help for option {0}" -f $opt.Name) -Level 'Info' -LogFile $logFile
                    Read-Host "Press Enter to continue"
                }
                continue
            }
            elseif ($userInput -eq 'A') {
                foreach ($row in $currentRows) { if (-not $row.IsHeader -and $row.Option) { $row.Option.State = $true } }
                Update-ChangedState
                Write-Log -Message 'Selected all visible options.' -Level 'Action' -LogFile $logFile
                continue
            }
            elseif ($userInput -eq 'N') {
                foreach ($row in $currentRows) { if (-not $row.IsHeader -and $row.Option) { $row.Option.State = $false } }
                Update-ChangedState
                Write-Log -Message 'Deselected all visible options.' -Level 'Action' -LogFile $logFile
                continue
            }
            elseif ($userInput -eq 'S') {
                try {
                    $user.Options = @()
                    foreach ($opt in $options) {
                        $user.Options += @{ ID = $opt.ID; State = $opt.State }
                        $opt.OriginalState = $opt.State
                    }
                    $user.LastModified = (Get-Date -Format 'yyyy-MM-dd')
                    $user.ModifiedBy = $env:USERNAME
                    $user.ChangeHistory += ("{0}: Saved config changes." -f (Get-Date -Format 'yyyy-MM-dd HH:mm'))
                    $user | ConvertTo-Json -Depth 5 | Set-Content $userConfigPath
                    Update-ChangedState
                    Write-Log -Message 'Saved user config.' -Level 'Info' -LogFile $logFile
                    Write-Host "Configuration saved." -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                }
                catch {
                    Write-Log -Message ("Error saving user config: {0}" -f $_) -Level 'Error' -LogFile $logFile
                    Write-Host "Error saving configuration: $($_.Exception.Message)" -ForegroundColor Red
                    Read-Host "Press Enter to continue"
                }
            }
            elseif ($userInput -eq 'R') {
                try {
                    $user = Get-Content $userConfigPath | ConvertFrom-Json
                    foreach ($opt in $options) {
                        $userOpt = $user.Options | Where-Object { $_.ID -eq $opt.ID }
                        if ($userOpt) {
                            $opt.State = $userOpt.State
                            $opt.OriginalState = $userOpt.State
                        }
                    }
                    Update-ChangedState
                    Write-Log -Message 'Reloaded user config.' -Level 'Info' -LogFile $logFile
                    Write-Host "Configuration reloaded." -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                }
                catch {
                    Write-Log -Message ("Error reloading user config: {0}" -f $_) -Level 'Error' -LogFile $logFile
                    Write-Host "Error reloading configuration: $($_.Exception.Message)" -ForegroundColor Red
                    Read-Host "Press Enter to continue"
                }
            }
            elseif ($userInput -eq 'Q') {
                Update-ChangedState
                $unsaved = ($options | Where-Object { $_.Changed }).Count
                if ($unsaved -gt 0) {
                    Write-Host "You have unsaved changes. Save before exiting? (Y/N)" -ForegroundColor Yellow
                    $ans = Read-Host "Save changes? (Y/N)"
                    if ($ans -match '^[Yy]$') {
                        try {
                            $user.Options = @()
                            foreach ($opt in $options) {
                                $user.Options += @{ ID = $opt.ID; State = $opt.State }
                                $opt.OriginalState = $opt.State
                            }
                            $user.LastModified = (Get-Date -Format 'yyyy-MM-dd')
                            $user.ModifiedBy = $env:USERNAME
                            $user.ChangeHistory += ("{0}: Saved config changes on exit." -f (Get-Date -Format 'yyyy-MM-dd HH:mm'))
                            $user | ConvertTo-Json -Depth 5 | Set-Content $userConfigPath
                            Update-ChangedState
                            Write-Log -Message 'Saved user config on exit.' -Level 'Info' -LogFile $logFile
                            Write-Host "Configuration saved." -ForegroundColor Green
                            Read-Host "Press Enter to continue"
                        }
                        catch {
                            Write-Log -Message ("Error saving user config on exit: {0}" -f $_) -Level 'Error' -LogFile $logFile
                            Write-Host "Error saving configuration: $($_.Exception.Message)" -ForegroundColor Red
                            Read-Host "Press Enter to continue"
                        }
                    }
                    else {
                        Write-Log -Message 'Exited without saving changes.' -Level 'Warning' -LogFile $logFile
                        Write-Host "Exited without saving changes." -ForegroundColor Yellow
                        Read-Host "Press Enter to continue"
                    }
                }
                break
            }
        }
        catch {
            Write-Log -Message ("Exception in menu loop: {0}" -f $_) -Level 'Error' -LogFile $logFile
            Write-Host "An unexpected error occurred: $($_.Exception.Message)" -ForegroundColor Red
            Read-Host "Press Enter to continue"
            continue
        }
    }
} # End of function Edit-DefaultDeploymentConfig
