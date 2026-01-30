# GOVERNANCE CONTRADICTION AUDIT — SUMMARY

**Date:** January 30, 2026  
**Audit Status:** Complete  
**Plans Created:** 4 contradictions identified and planned

---

## Executive Summary

Four contradicting governance rules have been identified across the AgentGov framework. Each contradiction pits two principles against each other. Plans have been drafted for resolving each conflict; they are persisted in `.github/prompts/` and awaiting user review and approval.

**All contradictions focus on contradicting rules only** (as requested). No governance file quality issues, redundancy, or optimization opportunities are included in this audit.

---

## Contradictions Identified

| # | Title | Severity | Status | Plan File |
| --- | --- | --- | --- | --- |
| 1 | ForEach-Object Loop Construct Ambiguity | Medium | Proposed | plan-20260130-foreach-loop-ambiguity.prompt.md |
| 2 | Bash POSIX Compliance vs. Strict Mode | High | Proposed | plan-20260130-bash-posix-contradiction.prompt.md |
| 3 | PowerShell CRLF Mandate vs. Idempotency | High | Proposed | plan-20260130-powershell-crlf-idempotency.prompt.md |
| 4 | Governance Hard Gate vs. Exemption Scope | High | Proposed | plan-20260130-hardgate-exemption-conflict.prompt.md |

---

## Contradiction #1: ForEach-Object Loop Construct Ambiguity

**Documents:** STANDARDS_POWERSHELL.md (Loop Constructs section)

**The Conflict:**

- "Prefer `foreach` for high-volume data and performance-sensitive loops"
- **BUT:** "Always use `-Process` with `ForEach-Object`" (implies broad acceptability)
- **AND:** "Use `ForEach-Object` when streaming in pipelines"

**The Problem:** Unclear decision tree. Are agents supposed to avoid `ForEach-Object` in non-pipeline contexts, or is the "always use -Process" statement meant to make it broadly acceptable?

**Recommendation:** Clarify with explicit decision tree:

- Default: `foreach` (preferred for in-memory data)
- Exception: `ForEach-Object -Process` (pipeline streaming only)

**Severity:** Medium (affects code generation consistency, not safety)

**Type:** Clarification (non-breaking)

---

## Contradiction #2: Bash POSIX Compliance vs. Strict Mode

**Documents:** PERSONA.md vs. STANDARDS_BASH.md

**The Conflict:**

- PERSONA.md (Framework Identity): "Writes all files... to applicable standards (**POSIX for Bash**)"
- STANDARDS_BASH.md (Implementation): Mandates `set -euo pipefail` and `IFS=$'\n\t'` as mandatory
- **Problem:** `set -euo pipefail` is **not POSIX-compliant**; it is Bash-specific

**The Deeper Issue:** The framework claims POSIX identity but mandates Bash-only features that violate POSIX. Downstream consumers expecting POSIX portability may be misled.

**Recommendation:** **Embrace Bash Explicitly** (Option B):

- Update PERSONA.md: Replace "POSIX for Bash" with "**Bash (4.x or later) for shell automation**"
- Add rationale to STANDARDS_BASH.md explaining the safety/portability trade-off
- Update relevant ADR to reflect Bash-first strategy

**Severity:** High (affects framework identity and consumer expectations)

**Type:** Breaking change (shifts framework commitment from POSIX to Bash)

**Impact:** Downstream projects expecting POSIX compatibility will be surprised. Mitigation: Provide clear, new governance identity.

---

## Contradiction #3: PowerShell CRLF Mandate vs. Cross-Platform Idempotency

**Documents:** STANDARDS_CORE.md vs. STANDARDS_POWERSHELL.md

**The Conflict:**

- STANDARDS_CORE.md §1.1 (Universal Principle): "**Idempotency:** All scripts must be re-runnable without side effects"
- STANDARDS_POWERSHELL.md (Platform-Specific): All PowerShell files **MUST** use CRLF line endings

**The Problem:** A file with CRLF on Windows has different bytes than the same file with LF on Linux/macOS. True idempotency means consistent state across platforms; CRLF mandate breaks this. The encoding becomes a platform-specific side effect.

**The Deeper Issue:** Agents on macOS/Linux are instructed to **convert line endings to CRLF**, but this is itself a non-idempotent step (the encoding changes as a side effect).

**Recommendation:** **Conditional CRLF** (Option C):

- Default: Use LF for cross-platform consistency and idempotency
- Exception: Use CRLF only for specific scenarios (Group Policy, DSC) with explicit justification
- Stage 1 of the plan: Test whether Windows GPO/DSC actually requires CRLF (modern systems likely normalize)

**Severity:** High (fundamental violation of idempotency principle)

**Type:** Breaking change (removes CRLF mandate, but aligns with core principles)

**Impact:** GPO/DSC deployments may be affected if CRLF is truly required. Plan includes testing to validate.

---

## Contradiction #4: Governance Hard Gate vs. Exemption Scope

**Documents:** .github/copilot-instructions.md vs. SPEC_PROTOCOL.md §3.3

**The Conflict:**

- .github/copilot-instructions.md (Hard Gate): "Typos in governance files: **Require a plan**" — "**No Exemptions**"
- SPEC_PROTOCOL.md §3.3 (Exempt Changes): "**Syntax fixes:** Correcting typos... may proceed **without** a persisted plan"

**The Problem:** Which rule applies to a typo in STANDARDS_POWERSHELL.md? The two documents give opposite answers.

**The Deeper Issue:** SPEC_PROTOCOL.md's exemptions were written for code files. copilot-instructions.md's Hard Gate treats governance files as special (and correctly so). The contradiction arises from conflicting scopes.

**Recommendation:** **Clarify Scope** (Non-Breaking):

- Update SPEC_PROTOCOL.md §3.3 to explicitly state: "Exemptions apply to **code files only**, not governance files"
- Update copilot-instructions.md to clarify: "This rule applies **only to governance files**"
- Add decision tree to help agents quickly determine which rule applies

**Severity:** High (affects agent behavior consistency and governance audit trail)

**Type:** Clarification (non-breaking operationally, but changes agent behavior)

**Impact:** Agents will consistently require plans for all governance file edits, improving durability and auditability.

---

## Next Steps

### For Review

1. **Review all four plans** in `.github/prompts/`:
   - [plan-20260130-foreach-loop-ambiguity.prompt.md](.github/prompts/plan-20260130-foreach-loop-ambiguity.prompt.md)
   - [plan-20260130-bash-posix-contradiction.prompt.md](.github/prompts/plan-20260130-bash-posix-contradiction.prompt.md)
   - [plan-20260130-powershell-crlf-idempotency.prompt.md](.github/prompts/plan-20260130-powershell-crlf-idempotency.prompt.md)
   - [plan-20260130-hardgate-exemption-conflict.prompt.md](.github/prompts/plan-20260130-hardgate-exemption-conflict.prompt.md)

2. **Assess priority and risk** for each contradiction:
   - **High Risk (1st):** Contradiction #4 (governance hard gate) — affects all governance workflows
   - **High Priority (2nd):** Contradiction #2 (Bash POSIX) — affects framework identity
   - **High Priority (3rd):** Contradiction #3 (CRLF idempotency) — affects core principle
   - **Medium Priority (4th):** Contradiction #1 (ForEach-Object) — affects code consistency

3. **Approve or request changes** for each plan
   - Each plan includes explicit Consent Gate questions for your review

### For Approval

Once you approve a plan, respond with:

> Approved: plan-TOPIC (e.g., Approved: plan-20260130-foreach-loop-ambiguity)

Then the coding phase can begin with full audit trail.

---

## Notes

- All plans follow SPEC_PROTOCOL.md structure (Problem Statement, Analysis, Stages, Checkpoints, Consent Gate)
- All plans are persisted in `.github/prompts/` for durability and auditability
- No code changes have been made yet; this is the Thinking Phase only
- Plans are ready for your review and approval

