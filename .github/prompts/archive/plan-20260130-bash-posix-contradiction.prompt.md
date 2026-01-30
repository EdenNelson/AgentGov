# PLAN: Resolve Bash POSIX Compliance vs. Strict Mode Contradiction

**Date:** January 30, 2026  
**Status:** Proposed  
**Scope:** Governance breaking change  
**Severity:** High (affects framework identity and code generation)

---

## Problem Statement

A core contradiction exists between two governance documents:

1. **PERSONA.md** (Framework Identity):
   - States: "Writes all files... to applicable standards (**POSIX for Bash**, etc.)"
   - This establishes POSIX shell compatibility as a governance principle

2. **STANDARDS_BASH.md** (Implementation Rule):
   - Mandates: `set -euo pipefail` and `IFS=$'\n\t'` as "MANDATORY"
   - These constructs are **not POSIX-compliant**; they are Bash-specific

**The Contradiction:** The framework claims POSIX compliance as an identity principle, but mandates Bash-only features that violate POSIX compliance.

**Impact:** 
- Agents receive conflicting guidance
- Code generation may claim POSIX compatibility while using Bash-specific syntax
- Downstream consumers expecting POSIX portability may receive Bash-only scripts
- Framework identity is undermined

---

## Analysis & Assessment

### Current State

**PERSONA.md §Institutional Memory** explicitly commits the framework to POSIX:
> "Writes all files (code, docs, scripts) to applicable standards (CommonMark for Markdown, **POSIX for Bash**, etc.)"

**STANDARDS_BASH.md §1.1** directly contradicts this:
```bash
#!/bin/bash                    # Bash shebang (explicit, not POSIX sh)
set -euo pipefail              # NOT POSIX (Bash extension)
IFS=$'\n\t'                    # NOT POSIX (Bash/ksh extension)
```

### Root Cause Analysis

**Why the contradiction exists:**

1. **PERSONA.md** was written to establish framework principles (POSIX = portable, maintainable)
2. **STANDARDS_BASH.md** was written to enforce safety (strict mode prevents common bugs)
3. **The conflict:** The author of STANDARDS_BASH.md prioritized safety over the POSIX principle, but did not formally update PERSONA.md to reflect the new priority

### Context: The "Zero-Cost" Constraint

From PERSONA.md §Institutional Memory:
> "We use what we have (AD, Google Workspace, Intune/Jamf)... Do not build containerized web apps... If it can be done with `bash` or `pwsh` and a cron job, do not over-engineer."

**Implication:** Bash scripts must run on:
- macOS (Bash 3.2 by default, can update to Bash 5+)
- Linux (Bash 4.x or 5.x)
- Windows (WSL, Git Bash, MSYS2, or Cygwin)

**Impact on POSIX choice:** POSIX shell (sh) runs on all these platforms. Bash is near-universal but adds a dependency. The choice between POSIX and Bash is **architectural** and affects portability.

### Assessment of Options

**Option A: Enforce POSIX Strictly**
- Keep PERSONA.md as-is (POSIX commitment)
- Replace STANDARDS_BASH.md with POSIX-safe alternatives:
  - Use `set -e` (supported by POSIX) instead of `set -euo pipefail`
  - Use standard `IFS` initialization
  - Accept slightly lower "safety" for greater portability
- **Trade-off:** Lose `pipefail` (safer error detection) and `u` (fail on undefined vars)

**Option B: Embrace Bash Explicitly**
- Update PERSONA.md: "Bash (4.x or later) is our standard for shell automation"
- Keep STANDARDS_BASH.md as-is (strict mode for safety)
- Accept that Bash-only scripts reduce portability
- Ensure all Bash scripts explicitly specify `#!/bin/bash` (clear signal)
- **Trade-off:** Reduce portability; gain safety and clarity

**Option C: Hybrid — POSIX by Default, Bash When Justified**
- Update PERSONA.md: "Prefer POSIX shell; use Bash only when safety or features justify the dependency"
- Update STANDARDS_BASH.md: Strict mode is optional; justify when used
- Create separate STANDARDS_POSIX.md for POSIX shell scripts
- Allow both, with explicit guidance on when each is appropriate
- **Trade-off:** More governance complexity; maximum flexibility

### Recommendation: **Option B (Embrace Bash)**

**Rationale:**

1. **Practical Reality:** K12 ESD endpoints all have Bash available
2. **Safety Priority:** `set -euo pipefail` prevents real bugs (silent failures, undefined var traps)
3. **Existing Momentum:** STANDARDS_BASH.md already mandates strict mode; changing this would be disruptive
4. **Framework Honesty:** If we cannot commit to POSIX portability, say so clearly
5. **Consumer Trust:** Downstream projects using AgentGov deserve clear, honest statements about dependencies

**Supporting Evidence:**
- PERSONA.md already acknowledges Windows/macOS/Linux as a "single logical fleet"
- Bash 4.x/5.x is available on all three platforms via native or WSL
- No mention of POSIX sh compatibility in PROJECT_CONTEXT.md (project-specific scope)
- The "Zero-Cost" architecture tolerates common tools; Bash is one

---

## Plan

### STAGE 1: Update PERSONA.md — Replace POSIX with Bash Commitment

**Objective:** Align PERSONA identity with actual framework requirements

**Deliverables:**
- [ ] PERSONA.md §Institutional Memory, line rewritten
  - OLD: "Writes all files... to applicable standards (CommonMark for Markdown, **POSIX for Bash**, etc.)"
  - NEW: "Writes all files... to applicable standards (CommonMark for Markdown, **Bash (4.x or later) for shell automation**, etc.)"
- [ ] Add rationale: "Bash is universally available on macOS, Linux, and Windows (WSL); strict mode (`set -euo pipefail`) prevents silent failures and undefined variable traps."

**Checkpoint:** PERSONA.md updated and reviewed

### STAGE 2: Update STANDARDS_BASH.md — Add Rationale and Scope

**Objective:** Explain why Bash-specific features are justified

**Deliverables:**
- [ ] STANDARDS_BASH.md §1.1 (The "Safety Net" Header): Add rationale paragraph
  - "Bash is the standard for shell automation in this framework. Strict mode (`set -euo pipefail`) is mandatory because it prevents silent failures, undefined variable errors, and other common shell bugs. This trades portability (POSIX sh compatibility) for safety and clarity."
- [ ] Add scope statement: "These standards apply to `*.sh` files authored as **Bash scripts**. If POSIX portability is required for a specific script, use `#!/bin/sh` and request alternative guidance."

**Checkpoint:** STANDARDS_BASH.md rationale added and reviewed

### STAGE 3: Create or Update ADR for Bash Standardization

**Objective:** Document the Bash commitment as an architectural decision (if not already present)

**Deliverables:**
- [ ] Check if ADR exists for Bash vs. POSIX (likely ADR-0005 or related)
- [ ] If no ADR exists: Create ADR documenting the decision
- [ ] If ADR exists: Verify it reflects Option B (Bash with justification)

**Checkpoint:** ADR reviewed or created

### STAGE 4: Regression Test (Probe)

**Objective:** Verify agents understand Bash is standard, POSIX is exception

**Deliverable:**
- [ ] Create prompt: "Write a shell script to list all files in a directory"
- [ ] Load updated governance (PERSONA.md + STANDARDS_BASH.md)
- [ ] Verify agent:
  - Uses `#!/bin/bash` shebang
  - Includes `set -euo pipefail`
  - Does NOT claim POSIX compatibility

**Checkpoint:** Probe test passes

---

## Consent Gate

**Change Type:** Breaking governance change (shifts framework identity from POSIX to Bash)

**Impact Scope:**
- **Framework consumers:** Expectations shift; Bash becomes explicit, POSIX removed
- **Existing code:** No changes required; clarification only
- **Future code:** All shell automation will target Bash (not POSIX)

**Migration Path:**
- If a consumer project requires POSIX shell compatibility, they must fork guidance or request a STANDARDS_POSIX.md variant

**User Approval Requested:**
1. Do you agree that Bash (with strict mode) is the standard for K12 ESD automation?
2. Is the trade-off acceptable: Safety/clarity over POSIX portability?
3. Should we create an alternative STANDARDS_POSIX.md for projects that need POSIX compatibility, or is Bash-only sufficient?

**Approved:** [ ] User confirms Bash-first strategy and implications

---

## References

- [PERSONA.md](../../PERSONA.md) §Institutional Memory (current POSIX claim)
- [STANDARDS_BASH.md](../../STANDARDS_BASH.md) §1.1 (Bash-specific strict mode)
- [SPEC_PROTOCOL.md](../../SPEC_PROTOCOL.md) (breaking change process)
- [STANDARDS_CORE.md](../../STANDARDS_CORE.md) §1.1 (Correctness, Clarity principle)

