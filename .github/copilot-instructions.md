<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

This project is a PowerShell 7 automation and validation toolkit for Windows device build certification. Follow the standards and requirements as detailed in the project documentation and user instructions.

# Additional Copilot Instructions

- All CLI menu documentation must follow the structure, indentation, and inline context comments as shown in `.website/user-guides/menu-structure.md`.
- Menu documentation must use the ASCII-art, indented, and annotated style for clarity and accessibility, with context for each action (e.g., "opens in Notepad", "stub", etc.).
- Always check for and respect recent manual documentation edits, especially in `.website/` and key Markdown files, before making automated changes.
- Use EN-AU spelling for all documentation and comments, except where user-facing output requires otherwise.
- All scripts must use the robust, root-based module import pattern and centralised logging as implemented in this project.
- The `.website/` folder is the canonical source for documentation; keep all scripts and documentation in sync.
- **CLI modules must never redirect to menus themselves—always return control to the caller for consistent menu flow. Menu navigation and flow must be managed by the calling (wrapper) function or script.**
- When introducing new properties to objects, always ensure they are defined at creation to avoid runtime errors.
- All menu and state logic must be modular, with state recalculation and redraw logic centralised and reusable.
- All CLI/menu changes must be regression-tested after every change, and all regressions must be fixed before proceeding.
- Never assume a property exists on a PSCustomObject unless it is explicitly defined at creation.
