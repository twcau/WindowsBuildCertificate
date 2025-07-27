---
applyTo: '**'
---
# Common Instructions

## Robustness, Testing, Validation & Error Prevention (2025-07-28 update)

- When adding new object properties, always initialise them at object creation to prevent runtime errors.
- All menu and state logic must be regression-tested after any change, and all regressions must be fixed before proceeding.

## Code Standards & Structure (2025-07-28 update)

- All helper functions (e.g., for state recalculation) must be defined in the correct scope and before use.

## Accessibility and Inclusivity Review (2025-07-28 update)

- All colour cues must have a non-colour fallback (e.g., asterisk for changed state).

## Change Management & Legacy Hygiene (2025-07-28 update)

- After any menu or state logic change, perform a full regression test of all menu flows and document any issues or fixes.

## First-Time Success Discipline (2025-07-28 update)

- Never introduce new regressions; always test for and resolve property, scope, or state errors after changes.
