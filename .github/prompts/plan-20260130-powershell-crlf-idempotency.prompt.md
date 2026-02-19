# PLAN: Resolve PowerShell CRLF Mandate vs. Cross-Platform Idempotency Conflict

**Date:** January 30, 2026  
**Status:** Proposed  
**Scope:** Governance breaking change  
**Severity:** High (affects idempotency principle and cross-platform consistency)

---

## Problem Statement

A fundamental architectural contradiction exists between two governance principles:

1. **.github/instructions/general-coding.instructions.md §1.1** (Universal Principle):
   - "**Idempotency:** All scripts must be re-runnable without side effects (Check → Test → Set pattern)"
   - Idempotency implies consistent state across all platforms

2. **.github/instructions/powershell.instructions.md §File Encoding** (Platform-Specific Mandate):
   - "All PowerShell files (*.ps1, *.psm1, *.psd1) **MUST** be Windows-compatible"
   - "**MANDATORY:** Line Endings: Use CRLF (`\r\n`, Windows-style)"
   - "If running on macOS/Linux: **You are responsible for conversion**"

**The Contradiction:** A file with CRLF line endings on Windows has different bytes than a file with LF line endings on Linux/macOS. Running the same script on both platforms means the files exist in **two different states**. This violates idempotency: "re-runnable without side effects" — but the file format **side effect** persists across platforms.

**Deeper Problem:** The .github/instructions/powershell.instructions.md rule implies that agents on macOS/Linux **must convert** files to CRLF. But this creates a side effect (encoding change that must be undone or preserved as-is). True idempotency would mean: "Run once, run again, same result." CRLF mandate breaks this.

**Impact:**
- Agents on macOS/Linux cannot generate PowerShell files that are truly idempotent across platforms
- File encoding becomes a platform-specific artifact, not a logical state
- Contradicts .github/instructions/general-coding.instructions.md's universal principle
- Creates friction: agents must "know" about CRLF conversion; this is a non-standard step

---

## Analysis & Assessment

### Current State & Context

**.github/instructions/powershell.instructions.md Rationale:**
> "PowerShell scripts execute on Windows servers and require **strict Windows file format** for proper execution in automated orchestration (DSC, Desired State Configuration; Group Policy startup/shutdown scripts; CI/CD pipelines; remote PowerShell execution via WinRM)."

**This is technically true for some scenarios** (e.g., Group Policy execution on Windows Domain Controllers), but is it universal?

**.github/instructions/general-coding.instructions.md Idempotency:**
> "All scripts must be re-runnable without side effects (Check → Test → Set pattern)."

**This is a universal principle** affecting all scripts, not just data processing.

### The Operational Reality: Three Scenarios

**Scenario A: Windows Domain Controller Group Policy**
- File must have CRLF (GPO enforces this)
- File encoding is not a "side effect"; it is a requirement
- **CRLF mandate is correct** for this context

**Scenario B: Cloud PowerShell (Azure, AWS)**
- Files can be LF or CRLF; most cloud environments normalize
- PowerShell on Linux/macOS runs fine with LF
- **CRLF mandate is unnecessary** for this context

**Scenario C: ESD K12 Endpoints (Mixed Fleet)**
- From .github/agents/architect.agent.md: "We treat all endpoints (Windows, macOS, Linux) as a single logical fleet"
- PowerShell Core 7+ runs on all three platforms
- Scripts must work on **all three**
- **CRLF mandate creates inconsistency** for this context

### Trade-off Analysis

**Option A: Keep CRLF Mandate (Current State)**
- **Pro:** Guarantees compatibility on Windows GPO/DSC
- **Con:** Violates idempotency on non-Windows platforms
- **Con:** Agents must handle encoding conversion (non-idempotent step)
- **Con:** Contradicts .github/instructions/general-coding.instructions.md principle
- **Impact:** Works for Windows-only deployments; breaks for cross-platform fleet

**Option B: Abandon CRLF Mandate — Use LF Universally**
- **Pro:** True idempotency; same file on all platforms
- **Pro:** Aligns with .github/instructions/general-coding.instructions.md
- **Pro:** Simpler for agents (no conversion logic)
- **Con:** May fail on Windows GPO/DSC (requires investigation)
- **Con:** Breaks .github/instructions/powershell.instructions.md assumption
- **Impact:** Works for cloud and cross-platform; may fail for Group Policy

**Option C: Conditional CRLF — Use LF by Default, CRLF Only for GPO Scripts**
- **Pro:** Preserves idempotency for 95% of scripts
- **Pro:** Still supports GPO/DSC scenarios with explicit opt-in
- **Pro:** Aligns with .github/instructions/general-coding.instructions.md
- **Pro:** Reduces complexity for agents
- **Con:** Requires new governance rule: "When to use CRLF"
- **Con:** Requires testing to verify GPO compatibility with LF files
- **Impact:** Maximum flexibility; requires testing

**Option D: Platform-Specific Variant (Advanced)**
- Create .github/instructions/powershell-gpo.instructions.md for Group Policy scripts (CRLF required)
- Create .github/instructions/powershell-core.instructions.md for cross-platform scripts (LF preferred)
- Agents choose based on deployment target
- **Pro:** Maximum clarity and flexibility
- **Con:** Governance overhead; two standards to maintain
- **Impact:** Complex; suitable only if both scenarios are common

### Recommendation: **Option C (Conditional CRLF)**

**Rationale:**

1. **.github/instructions/general-coding.instructions.md idempotency is non-negotiable** — it is a universal principle
2. **GPO/DSC support is important** but is a specific scenario, not universal
3. **K12 ESD reality:** Most deployments are cross-platform; GPO is a minority case
4. **Testing can resolve the unknowns:** We can verify that LF files work with GPO (likely they do, since modern Windows tools normalize)
5. **Honest governance:** Explicitly state when CRLF is required, rather than blanket mandate

---

## Plan

### STAGE 1: Research — Does Windows GPO/DSC Accept LF Line Endings?

**Objective:** Determine if the CRLF mandate is technically necessary or a precaution

**Deliverables:**
- [ ] Test PowerShell script with LF line endings on Windows GPO
- [ ] Test on Windows DSC
- [ ] Test on Windows WinRM remote execution
- [ ] Document findings: Does LF cause failures?

**Expected Outcome:** Likely that LF works fine (most modern Windows tools normalize), unless specific legacy version is in use

**Checkpoint:** Test results documented

### STAGE 2: Update .github/instructions/powershell.instructions.md — Conditional CRLF Rule

**Objective:** Replace blanket mandate with conditional rule

**Deliverables:**
- [ ] .github/instructions/powershell.instructions.md §File Encoding, rewritten:
  - Remove: "All PowerShell files MUST use CRLF"
  - Add: "Line Endings: Use LF (`\n`) by default for cross-platform compatibility. Use CRLF only for Group Policy or DSC scripts (see below)."
  - Add new subsection: "Group Policy & DSC Scripts (Conditional CRLF)"
    - Explain when CRLF is required (GPO, DSC)
    - Provide clear signal: `# GPO-SCRIPT: Requires CRLF` comment in file header
  - Simplify Enforcement section: Remove platform-specific conversion instructions

**Checkpoint:** .github/instructions/powershell.instructions.md updated and reviewed

### STAGE 3: Update .github/instructions/general-coding.instructions.md — Clarify Idempotency Definition

**Objective:** Explicitly state that idempotency includes file encoding

**Deliverables:**
- [ ] .github/instructions/general-coding.instructions.md §1.1 Idempotency, clarified:
  - Add: "Idempotency includes stable file encoding and format. Scripts must not introduce platform-specific encoding changes as side effects."
  - Link to updated .github/instructions/powershell.instructions.md conditional CRLF rule

**Checkpoint:** .github/instructions/general-coding.instructions.md updated

### STAGE 4: Create ADR or Update Existing

**Objective:** Document the decision rationale for posterity

**Deliverables:**
- [ ] Check if ADR-0005 (PowerShell Windows Compatibility) already covers CRLF
- [ ] If yes: Update ADR with conditional CRLF decision
- [ ] If no: Create new ADR for line ending strategy

**Checkpoint:** ADR created or updated

### STAGE 5: Regression Test (Probe)

**Objective:** Verify agents generate LF PowerShell files by default

**Deliverable:**
- [ ] Create prompt: "Write a PowerShell script to list all files in a directory"
- [ ] Load updated governance
- [ ] Verify agent:
  - Uses LF line endings (default)
  - Does NOT convert to CRLF
  - Does NOT include CRLF conversion instructions

**Secondary Test:**
- [ ] Create prompt: "Write a PowerShell Group Policy startup script"
- [ ] Verify agent:
  - Includes comment: `# GPO-SCRIPT: Requires CRLF`
  - OR explicitly uses CRLF with justification

**Checkpoint:** Probe tests pass

---

## Consent Gate

**Change Type:** Breaking governance change (removes CRLF mandate, aligns with idempotency)

**Compatibility Impact:**
- **Breaking for:** GPO/DSC deployments expecting CRLF (if LF is not compatible — TBD by Stage 1 testing)
- **Non-breaking for:** Cross-platform scripts (improved; now use LF consistently)
- **Migration Path:** If Stage 1 testing reveals LF is not compatible with GPO, provide conversion tooling or conditional guidance

**User Approval Requested:**
1. Do you agree that idempotency (.github/instructions/general-coding.instructions.md) should override platform-specific file encoding requirements?
2. Should we test whether Windows GPO/DSC actually requires CRLF, or assume it does?
3. For scenarios where CRLF IS required (if any), is a conditional rule acceptable?

**Approved:** [ ] User confirms idempotency-first approach and conditional CRLF acceptance

---

## References

- [.github/instructions/general-coding.instructions.md](../../.github/instructions/general-coding.instructions.md) §1.1 (Idempotency principle)
- [.github/instructions/powershell.instructions.md](../../.github/instructions/powershell.instructions.md) §File Encoding (current CRLF mandate)
- [.github/agents/architect.agent.md](../../.github/agents/architect.agent.md) §Institutional Memory (cross-platform fleet)
- [.github/instructions/spec-protocol.instructions.md](../../.github/instructions/spec-protocol.instructions.md) (breaking change process)
- [ADR-0005](../../.github/adr/0005-powershell-windows-compatibility.md) (existing PowerShell guidance)

