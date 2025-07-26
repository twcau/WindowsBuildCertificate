<!-- omit from toc -->

# WindowsBuildCertificate

A PowerShell 7 automation and validation toolkit for Windows device build certification. This project ensures all required software, settings, and configurations are completed, validated, and documented for ITSM and compliance.

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Folder Structure](#folder-structure)
- [Modules and Functions](#modules-and-functions)
- [Testing](#testing)
- [Logging and Troubleshooting](#logging-and-troubleshooting)
- [Accessibility](#accessibility)
- [Contributing](#contributing)
- [Changelog](#changelog)
- [License](#license)
- [Contact and Support](#contact-and-support)

## Project Overview

WindowsBuildCertificate automates and validates the build process for Windows devices, ensuring all required steps are completed and documented. It supports pre- and post-deployment scripting, user prompts, and robust logging for ITSM workflows.

## Features

- Modular PowerShell 7 scripts for pre/post build
- Device and configuration validation (naming, Secure Boot, BitLocker, PCR7, etc.)
- Company Portal, OneDrive, Office 365, Teams, Edge, and required app checks
- Intune and AD join validation
- Build certificate generation and export
- Robust logging, error handling, and accessibility
- Exportable scripts for OOBE and post-deployment
- Retype static documentation site

## Getting Started

1. Clone the repository and review the documentation.
2. Configure your build steps and modules as needed.
3. Use the provided scripts to automate and validate your device builds.

## Usage

- See `scripts/` for main entry points.
- See `modules/` for reusable functions.
- See `tests/` for Pester and validation scripts.

## Folder Structure

```plaintext
scripts/        # Main PowerShell scripts for build and export
modules/        # PowerShell modules and reusable functions
tests/          # Pester and validation scripts
resources/      # Supporting files and assets
.github/        # Copilot and GitHub configuration
.vscode/        # VS Code tasks and settings
.website/       # Retype documentation source
docs/           # Retype-generated static site (do not edit directly)
```

## Modules and Functions

See [MODULES.md](MODULES.md) for a full list of modules and functions.

## Testing

- Pester tests for critical functions
- Manual and automated validation steps

## Logging and Troubleshooting

- Logs are written to `$env:TEMP/WindowsBuildCertificate.log`
- See [KNOWNISSUES.md](KNOWNISSUES.md) for troubleshooting

## Accessibility

- All scripts and documentation follow accessibility and EN-AU standards

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.

## License

MIT License. See [LICENSE](LICENSE).

## Contact and Support

For support, see [SUPPORT.md](.website/support/support.md) or open a GitHub issue.
