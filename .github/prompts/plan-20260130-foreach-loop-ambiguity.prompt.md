# PLAN: Resolve ForEach-Object Loop Construct Ambiguity

**Date:** January 30, 2026  
**Status:** Proposed  
**Scope:** Governance clarification (non-breaking)  
**Severity:** Medium (affects code generation consistency)

---

## Problem Statement

.github/instructions/powershell.instructions.md contains contradictory guidance on loop constructs:

1. "Prefer `foreach` for high-volume data and performance-sensitive loops"
2. "Use `ForEach-Object` when streaming in pipelines to save memory or preserve pipeline semantics"
3. "Always use `-Process` with `ForEach-Object`"

**The contradiction:** The phrase "Always use `-Process`" suggests `ForEach-Object` is broadly acceptable, but the preference hierarchy suggests it should only be used in specific (pipeline/memory) contexts. This creates ambiguity for agents: Is `ForEach-Object` acceptable in all scenarios, or only when piping data?

**Impact:** Code generation is inconsistent. Agents may choose `ForEach-Object` in performance-sensitive loops (violating the preference rule) because the "always use -Process" statement makes it sound broadly acceptable.

---

## Analysis & Assessment

### Current State

.github/instructions/powershell.instructions.md §"Loop Constructs" attempts to establish a performance preference but muddles the guidance:

- Correct principle: `foreach` is faster and preferred for memory-intensive operations
- Correct principle: `ForEach-Object` is useful for pipeline streaming to preserve memory
- **Unclear:** The scope and conditions where each should be used

### Root Cause

The standard was written to cover two distinct use cases:

1. **Data processing loops** (where `foreach` is faster)
2. **Pipeline streaming** (where `ForEach-Object` is idiomatic)

But it conflates them in a way that makes the preference rule ambiguous.

### Proposed Resolution

Clarify the decision tree with explicit conditions for each construct:

1. **Default (use `foreach`):** Processing large or medium-sized collections in memory
2. **Use `ForEach-Object`:** Only when:
   - Piping data from a cmdlet/stream (e.g., `Get-ChildItem | ForEach-Object -Process { ... }`)
   - Streaming from a large external source to avoid loading entire dataset
   - Preserving pipeline semantics is critical
3. **Rationale section:** Explain the memory trade-off and when each applies

### Trade-offs

- **Pro:** Clearer guidance reduces inconsistent code generation
- **Con:** Requires a brief "Decision Tree" section, adding minimal context

### Risk Assessment

- **Low risk:** This is a clarification, not a breaking change
- **No user impact:** Agents will generate more consistent code
- **No existing code breakage:** This is guidance for future generation

---

## Plan

### STAGE 1: Update .github/instructions/powershell.instructions.md with Clarified Decision Tree

**Objective:** Replace ambiguous guidance with explicit decision tree

**Deliverables:**
- [ ] "Loop Constructs" section rewritten with clear conditions
- [ ] Decision tree explicitly states when to use `foreach` vs. `ForEach-Object`
- [ ] Performance rationale documented
- [ ] All examples updated to match clarified preference

**Example structure:**

```markdown
## Loop Constructs

### Decision Tree

Use **`foreach`** (default):
- Processing collections in memory
- Performance-sensitive or high-volume data
- No need to preserve pipeline streaming

Use **`ForEach-Object -Process`** (pipeline streaming):
- Piping data from cmdlets (e.g., `Get-ChildItem | ForEach-Object -Process`)
- Streaming from large external sources to conserve memory
- Preserving pipeline semantics is critical

### Examples

**foreach (preferred for in-memory data):**
```powershell
foreach ($item in $items) {
    Do-Something -Item $item
}
```

**ForEach-Object (pipeline streaming only):**
```powershell
Get-ChildItem -Path $directory | ForEach-Object -Process {
    Process-File -File $_
}
```
```

**Checkpoint:** .github/instructions/powershell.instructions.md "Loop Constructs" section reviewed and updated

### STAGE 2: Validate Against Existing ADRs

**Objective:** Ensure no ADR contradicts the clarified guidance

**Deliverables:**
- [ ] Review all PowerShell ADRs (ADR-0005, etc.) for loop construct rules
- [ ] No contradictions found or all are resolved

**Checkpoint:** ADR scan complete

### STAGE 3: Regression Test (Probe)

**Objective:** Verify that agents correctly interpret the clarified guidance

**Deliverable:**
- [ ] Create prompt that asks agent to refactor a high-volume loop using current standards
- [ ] Verify agent chooses `foreach`, not `ForEach-Object` for in-memory data
- [ ] Verify agent chooses `ForEach-Object` only for pipeline scenarios

**Checkpoint:** Probe test passes

---

## Consent Gate

**Change Type:** Non-breaking governance clarification

**User Approval Requested:** 
- Does the clarified decision tree accurately reflect the intended scope of `foreach` vs. `ForEach-Object`?
- Is the performance rationale clear and correct?

**Approved:** [ ] User confirms clarification is acceptable

---

## References

- [.github/instructions/powershell.instructions.md](../../.github/instructions/powershell.instructions.md) (current, ambiguous guidance)
- [.github/instructions/spec-protocol.instructions.md](../../.github/instructions/spec-protocol.instructions.md) (non-breaking governance changes)
- [.github/instructions/general-coding.instructions.md](../../.github/instructions/general-coding.instructions.md) §1.1 (Correctness, Clarity principle)

