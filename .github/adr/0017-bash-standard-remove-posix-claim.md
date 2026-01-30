# ADR-0017: Bash as Standard Shell — Remove POSIX Compliance Claim

**Date:** January 30, 2026  
**Status:** Accepted  
**Deciders:** Eden Nelson

---

## Problem

PERSONA.md claims "POSIX for Bash" as a governance standard, but STANDARDS_BASH.md mandates Bash-specific features (`set -euo pipefail`, `IFS=$'\n\t'`) that violate POSIX compatibility.

**Root Cause:** The POSIX claim was an AI suggestion that was not revisited. Given the K12 ESD deployment context (Windows/macOS/Linux fleet with Bash 4.x or 5.x available everywhere), POSIX portability is neither necessary nor a priority.

---

## Decision

**Adopt Bash as the explicit standard for shell automation.** Remove all claims of POSIX compliance from PERSONA.md and replace with explicit Bash 4.x or later commitment.

**Rationale:**

1. **Practical Reality:** K12 ESD endpoints all have Bash (native on macOS/Linux; available via WSL/Git Bash on Windows)
2. **Safety First:** `set -euo pipefail` prevents real bugs; strict mode is non-negotiable
3. **Honest Governance:** If we cannot commit to POSIX, say so explicitly
4. **Zero-Cost Architecture:** Bash is free and ubiquitous; no additional dependencies
5. **Consumer Trust:** Downstream projects deserve clear, truthful statements about shell requirements

---

## Consequences

### Positive

- Framework identity is honest and unambiguous
- No more contradiction between PERSONA (POSIX) and STANDARDS_BASH (Bash-specific)
- Agents have clear guidance: "Target Bash, not POSIX shell"
- Simplifies governance; removes a false claim

### Negative

- Projects requiring POSIX sh portability cannot use AgentGov shell standards
- **Mitigation:** Provide clear notice that Bash is required; offer alternative guidance if POSIX is critical

---

## Implementation

### Changes Made

1. **PERSONA.md** — Replace POSIX claim with explicit Bash commitment
2. **STANDARDS_BASH.md** — Add rationale explaining why Bash-specific features are justified

### Files Modified

- [PERSONA.md](../../PERSONA.md) (§Institutional Memory)
- [STANDARDS_BASH.md](../../STANDARDS_BASH.md) (§1 BASH STANDARDS, new rationale section)

---

## Related

- [Plan: Resolve Bash POSIX Contradiction](../.github/prompts/plan-20260130-bash-posix-contradiction.prompt.md) (analysis that led to this decision)
- [STANDARDS_BASH.md](../../STANDARDS_BASH.md) (Bash standards)
- [PERSONA.md](../../PERSONA.md) (Framework identity)

