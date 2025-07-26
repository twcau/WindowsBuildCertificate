<#!
.SYNOPSIS
    Entry point for the WindowsBuildCertificate CLI toolkit.
.DESCRIPTION
    Loads the CLI menu for automating and validating Windows device builds, per project specifications.
    Sets up robust project root resolution, logging, and module imports. Presents accessible, EN-AU compliant menu.
    See: https://github.com/twcau/WindowsBuildCertificate
.FILECREATED    2025-07-26
.FILELASTUPDATED 2025-07-26
.DOCUMENTATION  https://twcau.github.io/WindowsBuildCertificate/
#>

param(
    [string]$LogDirectory
)

$ErrorActionPreference = 'Stop'

# --- Robust Project Root Resolver ---
# Attempt to resolve project root using anchor files
function Resolve-WindowsBuildCertificateRoot {
    [CmdletBinding()]
    param ()
    $current = $PSScriptRoot
    while ($current -and !(Test-Path (Join-Path $current 'README.md'))) {
        $parent = Split-Path -Parent $current
        if ($parent -eq $current) { break }
        $current = $parent
    }
    if (!(Test-Path (Join-Path $current 'README.md'))) {
        throw 'Project root could not be resolved. README.md not found.'
    }
    return $current
}

$env:WindowsBuildCertificateRoot = Resolve-WindowsBuildCertificateRoot

if (-not $LogDirectory) {
    $LogDirectory = Join-Path $env:WindowsBuildCertificateRoot 'Logs'
}
if (!(Test-Path $LogDirectory)) {
    New-Item -Path $LogDirectory -ItemType Directory -Force | Out-Null
}

# --- Import Required Modules ---
$modules = @(
    'Logging',
    'BuildCertificate',
    'DeviceChecks',
    'AppChecks',
    'IntuneADChecks',
    'ExportScripts',
    'CLI/LogsCLI',
    'CLI/DeploymentCLI',
    'CLI/MainMenuCLI',
    'CLI/HelpCLI'
)
foreach ($mod in $modules) {
    $modPath = Join-Path $env:WindowsBuildCertificateRoot "modules/${mod}.psm1"
    if (Test-Path $modPath) {
        Import-Module $modPath -Force
    }
    else {
        Write-Warning ("Module not found: {0}" -f $modPath)
    }
}

# --- Start Logging ---
$timestamp = (Get-Date -Format 'yyyy-MM-dd-HHmmss')
$username = $env:USERNAME
$transcriptFile = Join-Path $LogDirectory ("WindowsBuildCertificate_{0}_{1}.log" -f $timestamp, $username)
$customLogFile = Join-Path $LogDirectory ("WindowsBuildCertificate_custom_{0}_{1}.log" -f $timestamp, $username)
Start-Transcript -Path $transcriptFile -Append
Clear-Host

# --- Menu Title (Project-wide) ---
$Global:MenuTitle = 'Windows Deployment Script Creator'

# --- Start CLI ---
$ConfigDirectory = Join-Path $env:WindowsBuildCertificateRoot 'DeploymentConfigs'
Show-MainMenu -LogDirectory $LogDirectory -logFile $customLogFile -ConfigDirectory $ConfigDirectory
