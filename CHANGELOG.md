<!-- omit from toc -->
# Changelog

## [Unreleased]

### [2025-07-27]

- New project standard: CLI modules must never redirect to menus themselves—always return control to the caller for consistent menu flow. Menu navigation and flow must be managed by the calling (wrapper) function or script. This ensures robust, predictable, and accessible menu behaviour throughout the project. Standard documented in design-philosophy.md, specification.md, accessibility.md, and Copilot instructions.

## [2025-07-28] CLI/Menu Robustness, Accessibility, and Regression-Prevention Improvements

- Centralised and modularised all menu and state logic for the configuration editor
- Ensured all object properties (e.g., Changed) are initialised at creation to prevent runtime errors
- Added/updated documentation for advanced menu features, accessibility, and troubleshooting
- Reinforced regression testing and no-regression policy for all menu/state changes
- Updated project and user documentation, Copilot instructions, and CommonInstructions to codify these standards
