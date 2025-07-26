<#!
.SYNOPSIS
    Provides all log management CLI, menu, and functions for WindowsBuildCertificate.
.DESCRIPTION
    Contains all logic for displaying, getting, and archiving logs, as well as the logs menu for the CLI.
    Designed for robust import and use from the main entry script.
    EN-AU spelling and accessible output throughout.
.FILECREATED    2025-07-26
.FILELASTUPDATED 2025-07-26
.AUTHOR         Michael Harris
.COPYRIGHT      Copyright (c) 2025, Michael Harris, All rights reserved.
.DOCUMENTATION  https://twcau.github.io/WindowsBuildCertificate/
.NOTES          EN-AU spelling and accessible output throughout.
#>

function Get-LogsMenu {
    <#
    .SYNOPSIS
        Displays the log management menu and handles user selection.
    .DESCRIPTION
        Presents options to view current/past logs, compress logs, or return to the main menu. Handles user input and calls the appropriate function.
    .PARAMETER LogDirectory
        The directory where log files are stored.
    .PARAMETER LogFile
        The current session log file path.
    .EXAMPLE
        Get-LogsMenu -LogDirectory $LogDirectory -LogFile $LogFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param(
        [string]$LogDirectory,
        [string]$LogFile
    )
    Clear-Host
    Write-Host ("=== {0}: Log Management ===" -f $Global:MenuTitle) -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. View current session log"
    Write-Host "2. View past session logs"
    Write-Host "3. Compress Previous Months' Logs"
    Write-Host "4. Back to main menu"
    Write-Host ""
    $logChoice = Read-Host "Select an option [1-4] (default: 4)"
    if ([string]::IsNullOrWhiteSpace($logChoice)) { $logChoice = '4' }
    Write-Log -Message ("User selected logs menu option: {0}" -f $logChoice) -Level 'Action' -MenuOption $logChoice -LogFile $LogFile
    switch ($logChoice) {
        '1' { Get-CurrentSessionLog -LogFile $LogFile -LogDirectory $LogDirectory }
        '2' { Get-PastSessionLogs -LogDirectory $LogDirectory }
        '3' { Save-OldLogs -LogDirectory $LogDirectory }
        '4' { Write-Log -Message 'User exited logs menu.' -Level 'Info' -LogFile $LogFile; return }
        default { Write-Log -Message ("Invalid logs menu selection: {0}" -f $logChoice) -Level 'Warning' -LogFile $LogFile; Write-Log -Message 'Invalid selection. Please choose 1-4.' -Level 'Warning' -LogFile $LogFile; Get-LogsMenu -LogDirectory $LogDirectory -LogFile $LogFile }
    }
}

function Get-CurrentSessionLog {
    <#
    .SYNOPSIS
        Opens the current session log file in Notepad.
    .DESCRIPTION
        Checks if the log file exists and opens it in Notepad. Logs the action and prompts the user to return to the logs menu.
    .PARAMETER LogFile
        The current session log file path.
    .PARAMETER LogDirectory
        The directory where log files are stored.
    .EXAMPLE
        Get-CurrentSessionLog -LogFile $LogFile -LogDirectory $LogDirectory
    .LINK
        https://learn.microsoft.com/powershell/module/microsoft.powershell.management/start-process
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param(
        [string]$LogFile,
        [string]$LogDirectory
    )
    if (Test-Path $LogFile) {
        Start-Process notepad.exe $LogFile
        Write-Log -Message ("Opened current session log: {0}" -f $LogFile) -Level 'Info' -LogFile $LogFile
        Write-Log -Message 'Current session log file has been opened in Notepad.' -Level 'Action' -LogFile $LogFile
        Write-Log -Message 'Press Enter to return to the logs menu.' -Level 'Info' -LogFile $LogFile
        Read-Host

    }
    else {
        Write-Log -Message ("Current session log not found: {0}" -f $LogFile) -Level 'Warning' -LogFile $LogFile
        Write-Log -Message 'Current session log not found.' -Level 'Error' -LogFile $LogFile
        Write-Log -Message 'Press Enter to return to the logs menu.' -Level 'Info' -LogFile $LogFile
        Read-Host
    }
    Get-LogsMenu -LogDirectory $LogDirectory -LogFile $LogFile
}

function Get-PastSessionLogs {
    <#
    .SYNOPSIS
        Allows the user to view past session logs.
    .DESCRIPTION
        Lists past log files and allows the user to select one to view in Notepad, using Out-GridView if available. Handles accessibility and fallback if Out-GridView is not present.
    .PARAMETER LogDirectory
        The directory where log files are stored.
    .EXAMPLE
        Get-PastSessionLogs -LogDirectory $LogDirectory
    .LINK
        https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/out-gridview
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param(
        [string]$LogDirectory
    )
    $logFiles = Get-ChildItem -Path $LogDirectory -Filter 'WindowsBuildCertificate_*.log' | Sort-Object LastWriteTime -Descending
    if ($logFiles) {
        Write-Host ""
        Write-Host "Use the grid view to select a log file to view. The newest files are at the top."  -ForegroundColor Yellow
        $selected = $null
        $outGridViewAvailable = $false
        if (Get-Command Out-GridView -ErrorAction SilentlyContinue -CommandType Cmdlet) {
            try {
                $selected = $logFiles | Out-GridView -Title 'Select a log file to view' -PassThru
                $outGridViewAvailable = $true
            }
            catch {
                $outGridViewAvailable = $false
            }
        }
        if (-not $outGridViewAvailable) {
            Write-Host "Out-GridView is not available in this session. Listing files in the console:" -ForegroundColor Red
            $i = 1
            foreach ($file in $logFiles) {
                Write-Host ("[{0}] {1}" -f $i, $file.Name)
                $i++
            }
            $choice = Read-Host "Enter the number of the log file to view, or press Enter to cancel"
            if ($choice -match '^[0-9]+$' -and $choice -ge 1 -and $choice -le $logFiles.Count) {
                $selected = $logFiles[$choice - 1]
            }
            else {
                $selected = $null
            }
        }
        if ($selected) {
            Start-Process notepad.exe $selected.FullName
        }
        Write-Host ""
        Write-Host "Press Enter to return to the logs menu." -ForegroundColor Yellow
        Read-Host
    }
    else {
        Write-Host "No past session logs found." -ForegroundColor Red
        Write-Host "Press Enter to return to the logs menu." -ForegroundColor Yellow
        Read-Host
    }
    Get-LogsMenu -LogDirectory $LogDirectory
}

function Save-OldLogs {
    <#
    .SYNOPSIS
        Compresses previous month's logs and removes originals.
    .DESCRIPTION
        Finds all logs from the previous month, compresses them into a zip file, and deletes the originals. Uses Compress-Archive if available, otherwise .NET methods.
    .PARAMETER LogDirectory
        The directory where log files are stored.
    .EXAMPLE
        Save-OldLogs -LogDirectory $LogDirectory
    .LINK
        https://learn.microsoft.com/powershell/module/microsoft.powershell.archive/compress-archive
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    param(
        [string]$LogDirectory
    )
    $now = Get-Date
    $lastMonth = $now.AddMonths(-1)
    $yearMonth = $lastMonth.ToString('yyyy-MM')
    $zipName = "Logs-{0}.zip" -f $yearMonth
    $zipPath = Join-Path $LogDirectory $zipName
    $logFiles = Get-ChildItem -Path $LogDirectory -Filter 'WindowsBuildCertificate_*.log' | Where-Object {
        $_.LastWriteTime.Year -eq $lastMonth.Year -and $_.LastWriteTime.Month -eq $lastMonth.Month
    }
    if ($logFiles) {
        if (Test-Path $zipPath) {
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            foreach ($file in $logFiles) {
                [System.IO.Compression.ZipFile]::CreateFromDirectory($LogDirectory, $zipPath)
                [System.IO.Compression.ZipFile]::CreateEntryFromFile($zipPath, $file.FullName, $file.Name)
            }
        }
        else {
            Compress-Archive -Path $logFiles.FullName -DestinationPath $zipPath
        }
        $logFiles | Remove-Item -Force
        Write-Host "" -ForegroundColor Yellow
        Write-Host ("Compressed {0} log(s) into {1}." -f $logFiles.Count, $zipName) -ForegroundColor Green
        Write-Host "Press Enter to return to the logs menu." -ForegroundColor Yellow
        Read-Host
    }
    else {
        Write-Host "" -ForegroundColor Yellow
        Write-Host "No logs found for the previous month to compress." -ForegroundColor Red
        Write-Host "Press Enter to return to the logs menu." -ForegroundColor Yellow
        Read-Host
    }
    Get-LogsMenu -LogDirectory $LogDirectory
}
