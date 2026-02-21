# PLAN: Remove Quote Counting Validation from validate-powershell.sh

**Date:** February 21, 2026  
**Status:** Pending Approval  
**Scope:** Internal tooling improvement (non-breaking)

## Problem Statement

The PowerShell validator script counts single and double quotes as a syntax check, rejecting files with odd quote counts. This causes false positives because:

1. Simple character counting doesn't understand string context (quotes within strings)
2. Doesn't account for escape sequences or special character representations
3. PowerShell has complex quoting rules that raw counting cannot validate
4. Redundant: PSScriptAnalyzer (Check 5) already performs real syntax validation

**Impact:** Developers get confusing validation failures on valid PowerShell scripts.

## Analysis & Assessment

**Options:**
1. Remove quote counting entirely (recommended)
2. Make quote counting optional/non-blocking
3. Try to improve quote counting logic (too complex; would need full parser)

**Rationale for Option 1 (Remove):**
- PSScriptAnalyzer is the authoritative parser and catches real syntax errors
- Quote counting adds no value and creates friction
- Simpler = fewer bugs and false positives
- Brace/bracket/parenthesis counts remain (more meaningful for basic balance checks)

**Risk:** Low—removing a check that was generating false positives improves reliability

## Plan

### Stage 1: Remove Quote Counting Validation
- Delete lines 103–110 (double quote and single quote count checks)
- Verify script structure remains sound
- **Checkpoint:** validate-powershell.sh edited; no syntax errors

### Stage 2: Verify Remaining Checks
- Confirm all other checks (line endings, encoding, braces/brackets/parens, PSScriptAnalyzer) still work
- **Checkpoint:** Script runs without error

### Stage 3: Update Help Text  
- Remove quote references from the help output (line ~160)
- **Checkpoint:** Help text reflects only actual checks

## Consent Gate

**Breaking change:** No  
**User-facing impact:** None (internal tooling only)  
**Developer impact:** Positive—fewer false validation failures on valid PowerShell code

**Approved:** [✓] Approved by Eden Nelson on 2026-02-21

## References

- File: `.github/scripts/validate-powershell.sh`
- Related standards: general-coding.instructions.md (Check Before Act)
- Validation principle: Use the most authoritative validator (PSScriptAnalyzer) as source of truth
