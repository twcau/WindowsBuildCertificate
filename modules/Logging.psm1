<#
.SYNOPSIS
Standardised logging and error handling functions for WindowsBuildCertificate.
.DESCRIPTION
Provides logging, transcript, and error handling utilities for all modules. All log entries include timestamp, username, level, and message. Use for all actions, errors, warnings, info, and menu selections.
#>

function Write-Log {
    <#
    .SYNOPSIS
        Writes a log entry to the log file and a user-friendly message to the terminal.
    .DESCRIPTION
        Full detail (timestamp, username, level, etc.) is written to the log file.
        Only the user-facing message is written to the terminal, with appropriate colour.
    .PARAMETER Message
        The log message.
    .PARAMETER Level
        The log level: Error, Warning, Info, Action, etc.
    .PARAMETER MenuOption
        (Optional) The menu option selected by the user.
    .PARAMETER LogFile
        (Optional) The log file path. If not provided, only writes to the terminal.
    .EXAMPLE
        Write-Log -Message 'User selected option 2' -Level 'Action' -MenuOption '2' -LogFile $logFile
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Message,
        [Parameter(Mandatory)]
        [ValidateSet('Error', 'Warning', 'Info', 'Action')]
        [string]$Level,
        [string]$MenuOption,
        [string]$LogFile
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $username = $env:USERNAME
    $logEntry = ('[{0}] [{1}] [{2}] {3}' -f $timestamp, $username, $Level, $Message)
    if ($MenuOption) {
        $logEntry += (' (Menu selection: {0})' -f $MenuOption)
    }
    # Write to log file only if provided
    if ($LogFile) {
        Add-Content -Path $LogFile -Value $logEntry
    }
    # Write to terminal (user-facing only, with colour, no timestamp/username/level)
    switch ($Level) {
        'Error' { Write-Host $Message -ForegroundColor Red }
        'Warning' { Write-Host $Message -ForegroundColor Yellow }
        'Info' { Write-Host $Message -ForegroundColor Cyan }
        'Action' { Write-Host $Message -ForegroundColor Green }
        default { Write-Host $Message }
    }
}

# ...existing code for logging and error handling...
