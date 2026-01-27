# ADR-0008: Resolve Write-Information vs Write-Verbose Conflict

## Status

Accepted

## Date

2026-01-27

## Context

The STANDARDS_POWERSHELL.md file contains conflicting guidance about the use of `Write-Information`:

1. **Section "Logging and Messaging"** states:
   > "Avoid `Write-Information` unless specifically targeting the information stream for an advanced harness; prefer `Write-Verbose` for general visibility."

2. **Section "Cmdlet and Parameter Usage → Parameter Usage Examples"** contradicts this with:
   > Bad: `Write-Output "Message"`; Good: `Write-Information -Message "Message"`

This creates ambiguity for AI code generation. The agent cannot determine when to use `Write-Information` vs `Write-Verbose` due to these conflicting directives.

## Decision

Remove the conflicting `Write-Information` example from the "Parameter Usage Examples" section in STANDARDS_POWERSHELL.md so the logging guidance consistently favors `Write-Verbose` for general visibility.

## Consequences

**Positive:**

- Eliminates conflicting signals in governance
- AI will make consistent choices for logging cmdlets

**Negative:**

- Example coverage is reduced by one item; additional examples may be needed later if gaps appear

**Risks:**

- May uncover additional related conflicts if testing reveals broader patterns

## Compliance

- **Standards:** This change enforces consistency within STANDARDS_POWERSHELL.md itself
- **Governance:** Impacts all PowerShell code generation workflows

---

## Target Rule (Phase 1: Rule Isolation)

**Phase Lock:**

- **Assigned To:** Unassigned
- **Started:** 2026-01-27
- **Status:** Complete

**Rule/Section:** STANDARDS_POWERSHELL.md → "Cmdlet and Parameter Usage → Parameter Usage Examples"

**Category:** Conflicting

**Rationale:**

The example contradicts the explicit guidance in the "Logging and Messaging" section. The "Logging and Messaging" section clearly states to prefer `Write-Verbose` over `Write-Information` for general visibility, but the example shows `Write-Information` as the correct approach for generic messages.

This creates a decision paralysis for AI: which rule takes precedence?

**Target Code:**

```markdown
### Parameter Usage Examples

- Bad: `Get-Content $file`; Good: `Get-Content -Path $file`
- Bad: `Write-Output "Message"`; Good: `Write-Information -Message "Message"`  # <-- CONFLICT
- Bad: `gci $path`; Good: `Get-ChildItem -Path $path`
```

**Important:** This ADR focuses on **ONE rule only** — the `Write-Information` example conflict.

## Test Plan (Phase 2)

**Phase Lock:**

- **Assigned To:** Maintainer
- **Started:** 2026-01-27
- **Status:** Skipped (manual verdict provided)

**Target Rule:** `Write-Information` usage example in Parameter Usage Examples

**Probe Design:**

- Skipped per maintainer verdict to remove the conflicting example without further testing.

## Execution Notes (Phase 3)

**Phase Lock:**

- **Assigned To:** Maintainer
- **Started:** 2026-01-27
- **Status:** Complete

**Baseline (Current Standards):**

- Result: Skipped (verdict-driven change)
- Behavior Observed: Not evaluated

**Change Applied:**

```text
Removed the "Bad: Write-Output; Good: Write-Information" example from STANDARDS_POWERSHELL.md → Parameter Usage Examples.
```

**Post-Change (Modified Standards):**

- Result: Not evaluated (no probe run)
- Behavior Observed: Expected to default to Write-Verbose per logging guidance

**Regression Verdict:** Not applicable; change is scope-limited to documentation

## Validation Results (Phase 4)

**Phase Lock:**

- **Assigned To:** Maintainer
- **Started:** 2026-01-27
- **Status:** Complete

**Final Decision:** Accepted — removed conflicting `Write-Information` example

**Implementation:**

- [x] Update STANDARDS_POWERSHELL.md with validated change
- [x] Verify targeted conflict resolved
- [x] Update ADR status to Accepted

**Next Steps:**

1. If additional logging examples are needed, add `Write-Verbose`-based samples in a future ADR.
2. Monitor future AI outputs for consistent `Write-Verbose` usage.
