<#!
.SYNOPSIS
    About, Help & Instructions page for Windows Deployment Script Creator CLI.
.DESCRIPTION
    Displays project information, copyright, license, and key links. Provides a numbered menu to open links in the browser, or press Enter/X to return to the main menu. Accessible, maintainable, and EN-AU compliant.
.FILECREATED    2025-07-26
.FILELASTUPDATED 2025-07-26
.AUTHOR         Michael Harris
.COPYRIGHT      Copyright (c) 2025, Michael Harris, All rights reserved.
.DOCUMENTATION  https://twcau.github.io/WindowsBuildCertificate/
.NOTES          EN-AU spelling and accessible output throughout.
#>

function Show-HelpMenu {
    <#
    .SYNOPSIS
        Displays the About, Help & Instructions menu for the CLI.
    .DESCRIPTION
        Shows project information, copyright, license, and documentation links. Allows the user to open links in the browser or return to the main menu. Logs all actions.
    .PARAMETER logFile
        The current session log file path.
    .EXAMPLE
        Show-HelpMenu -logFile $logFile
    .NOTES
        EN-AU spelling and accessible output throughout.
    #>
    [CmdletBinding()]
    param ([string]$logFile)
    Clear-Host
    Write-Host ("=== {0}: About, Help & Instructions ===" -f $Global:MenuTitle) -ForegroundColor Cyan
    Write-Host ""
    Write-Host "A modular PowerShell CLI toolkit to create, manage, and validate Windows deployment script configurations."
    Write-Host ""
    Write-Host "Copyright (c) 2025, Michael Harris, All rights reserved."
    Write-Host ""
    $licenseLink = "https://github.com/twcau/WindowsBuildCertificate/blob/main/LICENSE"
    Write-Host ("[1] Project License: {0}" -f $licenseLink)
    Write-Host ""
    Write-Host (('-' * 80))
    Write-Host ""
    Write-Host "Documentation and resources" -ForegroundColor Magenta
    Write-Host ""
    $links = @(
        @{ Label = "[2] Documentation & Manual"; Url = "https://twcau.github.io/WindowsBuildCertificate/" },
        @{ Label = "[3] Project README.md"; Url = "https://github.com/twcau/WindowsBuildCertificate/blob/main/README.md" },
        @{ Label = "[4] GitHub Repository"; Url = "https://github.com/twcau/WindowsBuildCertificate" }
    )
    foreach ($link in $links) {
        Write-Host ("{0}: {1}" -f $link.Label, $link.Url)
    }
    Write-Host ""
    Write-Host ("Enter a number to open a link, or press Enter/X to return to the main menu")
    $userInput = Read-Host "Selection"
    Write-Log -Message ("User selected help menu option: {0}" -f $userInput) -Level 'Action' -MenuOption $userInput -LogFile $logFile
    if ([string]::IsNullOrWhiteSpace($userInput) -or $userInput.Trim().ToUpper() -eq 'X') {
        Write-Log -Message 'User exited help menu.' -Level 'Info' -LogFile $logFile
        return
    }
    if ($userInput -match '^[1-4]$') {
        if ($userInput -eq '1') {
            $url = $licenseLink
        }
        else {
            $url = $links[[int]$userInput - 2].Url
        }
        try {
            Start-Process $url
            Write-Log -Message ("Opened help menu link: {0}" -f $url) -Level 'Info' -LogFile $logFile
            Write-Log -Message ("Opened {0} in your default browser." -f $url) -Level 'Action' -LogFile $logFile
        }
        catch {
            Write-Log -Message ("Failed to open help menu link: {0}. Error: {1}" -f $url, $_) -Level 'Error' -LogFile $logFile
            Write-Log -Message ("Unable to open {0}. Please copy and paste it into your browser." -f $url) -Level 'Warning' -LogFile $logFile
        }
        Write-Log -Message 'Press Enter to return to the main menu.' -Level 'Info' -LogFile $logFile
        Read-Host
    }
}
