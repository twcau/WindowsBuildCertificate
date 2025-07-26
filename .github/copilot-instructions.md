<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

This project is a PowerShell 7 automation and validation toolkit for Windows device build certification. Follow the standards and requirements as detailed in the project documentation and user instructions.

# Additional Copilot Instructions

- All CLI menu documentation must follow the structure, indentation, and inline context comments as shown in `.website/user-guides/menu-structure.md`.
- Menu documentation must use the ASCII-art, indented, and annotated style for clarity and accessibility, with context for each action (e.g., "opens in Notepad", "stub", etc.).
- Always check for and respect recent manual documentation edits, especially in `.website/` and key Markdown files, before making automated changes.
- Use EN-AU spelling for all documentation and comments, except where user-facing output requires otherwise.
- All scripts must use the robust, root-based module import pattern and centralised logging as implemented in this project.
- The `.website/` folder is the canonical source for documentation; keep all scripts and documentation in sync.
