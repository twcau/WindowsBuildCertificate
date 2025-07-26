<!-- omit from toc -->
# WindowsBuildCertificate

A PowerShell 7 automation and validation toolkit for Windows device build certification. This project ensures all required software, settings, and configurations are completed, validated, and documented for ITSM and compliance.

> [!WARNING] Extreme Alpha - Not even close to being intended for prime time
> This repository is still under major development and testing, and isn't even close to being ready for prime time use. It's great that you're interested in it however, and feel welcome to let me know if you feel there's anything that could be done or enhanced as I get this ready.

## Table of Contents
- [Table of Contents](#table-of-contents)
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

For more information, please see [Project Overview](https://twcau.github.io/WindowsBuildCertificate/project-overview/specification/).

## Features

- Modular PowerShell 7 scripts for pre/post build
- Device and configuration validation (naming, Secure Boot, BitLocker, PCR7, etc.)
- Company Portal, OneDrive, Office 365, Teams, Edge, and required app checks
- Intune and AD join validation
- Build certificate generation and export
- Robust logging, error handling, and accessibility
- Exportable scripts for OOBE and post-deployment integration

For more information, please see [Features](https://twcau.github.io/WindowsBuildCertificate/project-overview/specification/).

## Getting Started

For more information, please see [Getting Started](https://twcau.github.io/WindowsBuildCertificate/user-guides/getting-started/).

1. Clone the repository and review the documentation.
2. Configure your build steps and modules as needed.
3. Use the provided scripts to automate and validate your device builds.

## Usage

- See `scripts/` for main entry points.
- See `modules/` for reusable functions.
- See `tests/` for Pester and validation scripts.

For more information, please see [Menu Structure](https://twcau.github.io/WindowsBuildCertificate/user-guides/menu-structure/).

## Folder Structure

For more information, please see [Folder Structure](https://twcau.github.io/WindowsBuildCertificate/project-overview/folder-structure/).

## Modules and Functions

For more information, please see [Modules and Functions](https://twcau.github.io/WindowsBuildCertificate/code/modules/).

## Testing

- Pester tests for critical functions
- Manual and automated validation steps

For more information, please see [Testing](https://twcau.github.io/WindowsBuildCertificate/user-guides/testing/).

## Logging and Troubleshooting

- Logs are written to `$env:TEMP/WindowsBuildCertificate.log`
- See [KNOWNISSUES.md](KNOWNISSUES.md) for troubleshooting

## Accessibility

- All scripts and documentation follow accessibility and EN-AU standards

For more information, please see [Accessibility](https://twcau.github.io/WindowsBuildCertificate/user-guides/accessibility/).

## Contributing

For guidelines, please see [Contributing](https://twcau.github.io/WindowsBuildCertificate/contributing/contributing/).

## Changelog

For release history, please see [Changelog](https://twcau.github.io/WindowsBuildCertificate/CHANGELOG/).

## License

MIT License. See [LICENSE](LICENSE).

## Contact and Support

For support or to open a GitHub issue, please see [Support](https://twcau.github.io/WindowsBuildCertificate/support/support/).
