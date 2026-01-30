# ADR-0014: ASCII Hyphens Required in PowerShell String Literals

## Status

Accepted

## Date

2026-01-30

## Context

PowerShell string literals must maintain ASCII compatibility and cross-platform consistency. Em dash characters (—, Unicode U+2014) can cause parsing ambiguity, encoding issues in automated systems, and display inconsistencies across terminal environments. The use of em dash in strings creates a hidden coupling to specific code editors or input methods (e.g., macOS Smart Quotes) and introduces friction during code review and refactoring.

PowerShell developers working on macOS (with Smart Quotes enabled in VS Code or other editors) may inadvertently introduce em dashes into string literals. This introduces:

- Encoding sensitivity (UTF-8 with/without BOM complications)
- Terminal display inconsistencies
- Git diff noise (em dash vs. hyphen appears as a character substitution)
- Downstream automation failures if systems expect strict ASCII

## Decision

**All PowerShell string literals must use standard ASCII hyphens (`-`, U+002D) in place of em dashes (—, U+2014).**

This rule applies to:

- String literals in double quotes: `"This is a string-value"`
- String literals in single quotes: `'This is a string-value'`
- String literals in here-strings: `@"..."-value...@"`
- Configuration keys or comments describing hyphens: Document using backticks for code formatting: `Use the -Value parameter`

## Consequences

- **Positive:**

  - Consistent string encoding across macOS, Linux, and Windows development environments
  - Reduced git diff noise (no accidental character substitutions)
  - Improved automation robustness (no encoding surprises in CI/CD pipelines)
  - Simpler code review (no "is that an em dash or hyphen?" confusion)
  - Compliance with cross-platform PowerShell Core standards

- **Negative:**

  - Requires awareness when copying strings from typographically-advanced sources (e.g., Word, Markdown with smart quotes)
  - Editor configuration (disable Smart Quotes in VS Code PowerShell context) needed on macOS

- **Risks:**

  - Editor settings may override this rule if Smart Quotes are enabled; governance training and linter enforcement (Pester rules) mitigate this

## Compliance

- **Standards:** This rule aligns with STANDARDS_POWERSHELL.md Naming and Style principles (clarity, cross-platform consistency, correctness over brevity).
- **Governance:** Integrated into STANDARDS_POWERSHELL.md § Naming and Style.
- **Enforcement:** Agents must inspect generated PowerShell strings for em dashes and replace with hyphens before finalization. Future Pester linting rules (if adopted) should detect and reject em dashes in string literals.

## Related Standards

- [STANDARDS_POWERSHELL.md](../../STANDARDS_POWERSHELL.md) — Naming and Style section
- [STANDARDS_CORE.md](../../STANDARDS_CORE.md) — Cross-platform consistency principle

## Prior Analysis

- Identified through governance maintenance review of PowerShell agent constraints.
